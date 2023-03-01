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


# resource for making a custom role from the set of permission
resource "google_project_iam_custom_role" "my-custom-role" {
  role_id     = var.role_id
  title       = "Corestack-gcp-custom-role-test"
  description = "Custom role for the corestack gcp module"
  permission = ["compute.disks.list", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "orgpolicy.policy.set", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.containerthreatdetectionsettings.update", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.update", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.update", "securitycenter.securitycentersettings.get", "securitycenter.securitycentersettings.update", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.securityhealthanalyticssettings.update", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.subscription.get", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.virtualmachinethreatdetectionsettings.update", "securitycenter.websecurityscannersettings.get", "securitycenter.websecurityscannersettings.update", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}
# resource for assigning the custom role to the service account 
resource "google_project_iam_member" "binding_role" {
  for_each = var.assign_role
  project = var.project_id
  role   = each.value == null ? "projects/${var.project_id}/roles/${var.role_id}" : "roles/${each.value}"
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

