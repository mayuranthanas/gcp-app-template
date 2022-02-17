resource "google_cloudfunctions_function" "gcf-java-sample" {
    project               = var.project_id
    name                  = "sk_gcf_java_sample"
    region                = var.region
    available_memory_mb   = 128
    timeout               = 300
    entry_point           = "HelloWorld"
    runtime               = "java11"
    trigger_http          = true    
    source_repository {
    url = "https://source.developers.google.com/projects/${var.project_id}/repos/github_{git-repo-name}/moveable-aliases/main/paths/src"
    }
#   environment_variables = yamldecode(file("/path/to/env.yaml"))
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker_java" {
    project               = var.project_id
    region                = var.region
    cloud_function = google_cloudfunctions_function.gcf-java-sample.name
    role   = "roles/cloudfunctions.invoker"
    member = "domain:telus.com"
}