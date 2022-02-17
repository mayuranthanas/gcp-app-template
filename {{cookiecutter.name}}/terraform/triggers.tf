resource "google_cloudbuild_trigger" "build-trigger" {
  provider    = google-beta
  project = var.project_id
  description = "GitHub Repository Trigger var.github_owner/var.github_repository (var.branch_name)"
  name= var.trigger_name

  github {
    owner = var.github_owner
    name  = var.github_repository
    push {
      branch = var.branch_name
    }
  }
 
  filename = var.cloud_build_file
}
