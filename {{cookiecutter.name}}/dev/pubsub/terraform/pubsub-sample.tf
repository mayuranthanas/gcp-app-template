resource "google_pubsub_topic" "example" {
  project = var.project_id
  name    = "{{ cookiecutter.pubsub.topic }}"
}

resource "google_pubsub_subscription" "example" {
  project = var.project_id
  name    = "{{ cookiecutter.pubsub.subscription }}"
  topic   = google_pubsub_topic.example.name
  
  # Keep messages for 20 minutes 
  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }

  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering  = false  
}