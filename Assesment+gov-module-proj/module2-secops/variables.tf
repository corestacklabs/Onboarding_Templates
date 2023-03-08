variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}


variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "assign_role" {
  type = set(string)
  description = "Assign Role"
  default = ["viewer"]
  nullable = true
}

variable "role_id" {
  type = string
  description = "Role ID"
  nullable = true
}

variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com"]
}

