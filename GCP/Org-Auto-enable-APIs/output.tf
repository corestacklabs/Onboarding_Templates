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

output "state_bucket_name" {
  description = "Cloud Storage bucket name where state is stored"
  value       = google_storage_bucket.state.name
}

output "state_file_path" {
  description = "Full path to the state file in Cloud Storage"
  value       = "gs://${google_storage_bucket.state.name}/${var.state_file}"
}