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
  checkrole = var.role_id == null ? 0:1
}
#data collector 
data "google_projects" "my-org-projects" {
  filter = "parent.id:${var.org_id}"
}

# resource for making a custom role from the set of permission
resource "google_organization_iam_custom_role" "my-custom-role" {
  count = local.checkrole
  role_id     = var.role_id
  org_id      = var.org_id
  title       = "custom-role-org-core-ag"
  description = "Custom role for the corestack gcp module"
  permissions = var.permissionsec == null ? var.permission_nosecops : var.permission_full
}
# resource for assigning the custom role to the service account 
resource "google_organization_iam_member" "binding_custom_role" {
  for_each = var.assign_role
  org_id = var.org_id
  role   = var.role_id == null ? "roles/${each.value}" : "organizations/${var.org_id}/roles/${var.role_id}"
  member = "serviceAccount:${var.service_account_email}"
  depends_on = [
    google_organization_iam_custom_role.my-custom-role
  ]
}

# Resource to execute the python script that will enable the apis. 
resource "null_resource" "Project_script" {
 provisioner "local-exec" {  
    command = "/bin/python3 extractor.py"
  }
  depends_on = [
    google_organization_iam_member.binding_custom_role
  ]
}

