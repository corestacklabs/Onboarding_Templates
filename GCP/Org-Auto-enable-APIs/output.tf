output "function_uri" {
  description = "Cloud Run URL behind the function"
  value       = google_cloudfunctions2_function.function.service_config[0].uri
}

output "scheduler_job_name" {
  value = google_cloud_scheduler_job.daily.name
}

output "pubsub_topic" {
  value = google_pubsub_topic.topic.name
}

output "service_account_email" {
  value = google_service_account.sa.email
}