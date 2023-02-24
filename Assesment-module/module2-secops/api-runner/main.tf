provider "google" {
  project     = "cs-internal-cust-suc-cloudops"
  region      = "asia-south1"
  zone        = "asia-south1-a"
}
resource "google_project_service" "api_proj_enabler" {
    project = var.orgproject
    for_each = var.api
    service = each.value
}