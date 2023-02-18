variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}
variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "org_id" {
  type = string
  description = "Organization ID"
}
variable "type" {
  default = "Assesment"
  description = "Select Assesment or Governance+assesments"
  type = string
  validation {
    condition = contains(["Assesment","Governance+assesments"],var.type)
    error_message = "Select from only this 2: Select Assesment or Governance+assesments"
  }
}
variable "role_id" {
  type = string
  description = "Role ID"
}
variable "assment_permisson" {
  type = set(string)
  description = "All the permisssion for Assesment"
  default = [""]
}

variable "assmentgovpermisson" {
  type = set(string)
  description = "All permission for Assesment + Governace"
  default = [""]
}
variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
}

