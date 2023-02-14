variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}
variable "role" {
  type = set(string)
  default = ["viewer"]
  description = "All the roles that have to be assigned. Please do include viewer role atleast"
}
variable "account_id" {
  type = string 
  description = "Service account ID"
}

variable "display_name" {
  type = string
  description = "Name of the service account"
}
variable "new_bucket_name" {
  type = string
  description = "Name of the bucket"
}
variable "bucket_location" {
  type = string
  description = "Location in which the bucket is hosted"
}

variable "dataset_location" {
  type = string
  description = "Dataset hosted location"
}

variable "dataset_id" {
  type = string
  description = "Table ID"
}