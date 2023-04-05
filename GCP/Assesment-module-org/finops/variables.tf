variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}


variable "org_id" {
  type = string
  description = "Organization ID"
}

variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com"]
}

