variable "api" {
type = set(string)
description = "List of APIS that needs to be enabled per project"
}
variable "orgproject" {
  type = string
  description = "org proj"
}