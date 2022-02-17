resource "google_cloud_scheduler_job" "sample-py-job" {
  name        = "job-sk-py-sample"
  description = "Sample http python job to write to the log"
  project     = var.project_id
  schedule    = "0 0 * * *"
  time_zone   = "America/Toronto"
  region      = var.region

  http_target {
    http_method = "GET"
    uri         = "https://${var.region}-${var.project_id}.cloudfunctions.net/${google_cloudfunctions_function.gcf-py-sample.name}"
    oidc_token {
      service_account_email = "${var.project_id}@appspot.gserviceaccount.com"
    }
  }
}
