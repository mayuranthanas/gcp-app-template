resource "google_storage_bucket" "static-site" {
  project       = var.project_id
  name          = "starter-kit-sample-bucket"
  location      = "NORTHAMERICA-NORTHEAST1"
  force_destroy = true
  uniform_bucket_level_access = true  
}
