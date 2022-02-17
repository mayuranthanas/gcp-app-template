resource "google_cloudfunctions_function" "gcf-js-sample" {
    project               = var.project_id
    name                  = "sk_gcf_js_sample"
    region                = var.region
    available_memory_mb   = 128
    timeout               = 300
    entry_point           = "helloHttp"
    runtime               = "nodejs14"
    trigger_http          = true
    source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/github_{git-repo-name}/moveable-aliases/main/paths/src"
    }
#   environment_variables = yamldecode(file("/path/to/env.yaml"))
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker_js" {
    project               = var.project_id
    region                = var.region
    cloud_function        = google_cloudfunctions_function.gcf-js-sample.name
    role                  = "roles/cloudfunctions.invoker"
    member                = "domain:telus.com"
}