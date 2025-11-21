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

output "firestore_database_name" {
  description = "Firestore database name (use this to find your data in Firestore console)"
  value       = google_firestore_database.state.name
}

output "firestore_collection_path" {
  description = "Full path to the Firestore collection where state is stored"
  value       = "${var.state_collection}/${var.state_doc}"
}