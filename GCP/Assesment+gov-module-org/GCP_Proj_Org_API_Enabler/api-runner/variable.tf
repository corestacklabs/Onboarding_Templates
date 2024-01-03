variable "api" {
type = set(string)
description = "List of APIS that needs to be enabled per project"
default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com", "sqladmin.googleapis.com", "monitoring.googleapis.com"] 
}
variable "orgproject" {
  type = string
  description = "org proj"
}