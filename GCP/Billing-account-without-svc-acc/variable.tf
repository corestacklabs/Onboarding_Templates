variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "bucket_location" {
  type = string
  description = "Location in which the bucket is hosted"
}

variable "table_id" {
  type = string
  description = "Table ID"
}

variable "api" {
  type = set(string)
  description = "API to enable"
  default = ["compute.googleapis.com","cloudresourcemanager.googleapis.com", "cloudbilling.googleapis.com", "recommender.googleapis.com"]
}