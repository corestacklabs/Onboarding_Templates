variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}
variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "assign_role" {
  type = list(string)
  description = "Assign Role"
  default = ["viewer"]
  nullable = true
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
}

