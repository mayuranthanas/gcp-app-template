resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "random_password" "db_password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "google_secret_manager_secret" "secret_db_password" {
   project = var.project_id
   secret_id = "secret_db_password"
   labels = {
     label = "secret_db_password"
   }
   replication {
     user_managed {
       replicas {
         location = var.region
     }
   }
 }
}

resource "google_secret_manager_secret_version" "secret_db_password_version" {
   secret = google_secret_manager_secret.secret_db_password.id
   secret_data = random_password.db_password.result
}

module "cloudsql" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source            = "git::ssh://git@github.com/telus/tf-module-gcp-cloudsql.git?ref=v0.3.1%2Btf.0.13.3"
  project_id        = var.project_id
  db_server_name    = "${var.project_name}-${var.instance_suffix}"
  db_name           = "${var.db_name}-${random_id.db_name_suffix.hex}"
  db_version        = var.db_version
  private_network   = var.shared_vpc_network
}

resource "google_sql_user" "users" {
  name        = var.db_user
  project     = var.project_id
  instance    = module.cloudsql.instance_name
  password    = random_password.db_password.result
  depends_on  = [module.cloudsql]
}

module "my_app_workload_identity" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-workload-identity?ref=v0.0.2"
  gsa-name      = "gsa-${var.project_name}"
  ksa-name      = var.ksa_name
  namespace     = var.gke_namespace
  project_id    = var.project_id
  roles         = var.gsa_roles
  cluster_env   = var.gke_cluster_env
}