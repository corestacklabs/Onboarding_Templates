variable "project_id" {
  description = "Seed project where infra is deployed"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID (numeric string)"
  type        = string
}

variable "region" {
  description = "Region for Cloud Functions / Eventarc"
  type        = string
  default     = "us-central1"
}

variable "location_id" {
  description = "Firestore database location (e.g., nam5, asia-south1)"
  type        = string
  default     = "nam5"
}

variable "scheduler_time_zone" {
  description = "IANA time zone for the scheduler"
  type        = string
  default     = "Asia/Kolkata"
}

variable "scheduler_cron" {
  description = "Cron schedule for the daily run"
  type        = string
  default     = "0 9 * * *" # 09:00 IST
}

variable "state_collection" {
  description = "Firestore collection for state"
  type        = string
  default     = "org-inventory"
}

variable "state_doc" {
  description = "Firestore document name for seen projects"
  type        = string
  default     = "projects-seen"
}
