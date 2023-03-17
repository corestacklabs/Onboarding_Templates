variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}

variable "assign_role" {
  type = set(string)
  description = "Predefined roles"
  default = ["viewer","pubsub.admin","securitycenter.adminEditor", "monitoring.editor","logging.configWriter","compute.admin"]
}
variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}
 
variable "org_id" {
  type = string
  description = "Organization ID"
}

variable "role_id" {
  type = string
  description = "Role ID"
  default = null
  nullable  = true
}

variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com", "sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
}

