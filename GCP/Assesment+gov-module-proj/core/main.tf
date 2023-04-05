# Terraform file for the creation of service account and providing access

#Header start
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
#Header End
locals {
  checkroleid = var.role_id == null ? 0 : 1
}
# resource for making a custom role from the set of permission
resource "google_project_iam_custom_role" "my-custom-role" {
  count = local.checkroleid
  role_id     =  var.role_id
  title       = "custom-role-core-ag-proj"
  description = "Custom role for the corestack gcp module A+G Project"
  permissions = var.permissionsec == null ? var.permission_nosecops : var.permission_full
}
resource "google_project_iam_member" "binding_role" {
  for_each = var.assign_role
  role   =  var.role_id == null ? "roles/${each.value}" : "projects/${var.project_id}/roles/${var.role_id}"
  project = var.project_id
  member = "serviceAccount:${var.service_account_email}"
  depends_on = [
    google_project_iam_custom_role.my-custom-role
  ]
}

resource "google_project_service" "api_proj_enabler" {
    project = var.project_id
    for_each = var.api
    service = each.value
    depends_on = [
      google_project_iam_member.binding_role
    ]
}

