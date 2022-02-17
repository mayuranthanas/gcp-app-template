module "firestore" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-firestore.git?ref=v0.3.0%2Btf.0.13.3"
  project_id    = var.project_id
  region        = var.region
  database_type = "CLOUD_FIRESTORE" 
}