variable "project_id" {
  type = string
}

resource "google_monitoring_dashboard" "{{ cookiecutter.application }}_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/{{ cookiecutter.application }}-dashboard.json", { project_id = var.project_id })
}
