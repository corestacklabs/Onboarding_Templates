terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
resource "google_project_service" "api_proj_enabler" {
    project = var.orgproject
    for_each = var.api
    service = each.value
}