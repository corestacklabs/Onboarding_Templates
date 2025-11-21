variable "project_id" {
  description = "Seed project where infra is deployed"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID (numeric string)"
  type        = string
}

variable "region" {
  description = "Region for Cloud Functions / Eventarc (must comply with organization resource location constraints)"
  type        = string
  # No default - must be set to a region allowed by org policy
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
