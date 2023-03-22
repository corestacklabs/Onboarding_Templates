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
  roleid = "customrolepsecopsa"
}
# resource for making a custom role from the set of permission
resource "google_project_iam_custom_role" "my-custom-role" {
  project = var.project_id
  role_id     =  local.roleid
  title       = "custom-role-project-secops-a"
  description = "Custom role for the corestack gcp module"
  permissions = ["compute.disks.list", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "resourcemanager.projects.get", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.securitycentersettings.get", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.websecurityscannersettings.get", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}
# resource for assigning the custom role to the service account 
resource "google_project_iam_member" "binding_role" {
  project = var.project_id
  role   =  "projects/${var.project_id}/roles/${local.roleid}"
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

