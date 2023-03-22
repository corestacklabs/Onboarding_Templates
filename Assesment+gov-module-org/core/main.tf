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
  permissions = ["appengine.applications.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list", "bigquery.datasets.get", "bigquery.jobs.get", "bigquery.jobs.list", "bigquery.reservations.get", "bigquery.reservations.list", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "billing.budgets.create", "billing.budgets.get", "billing.budgets.list", "billing.budgets.update", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudiot.registries.get", "cloudiot.registries.list", "cloudsecurityscanner.scans.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "cloudsql.instances.update", "composer.environments.list", "compute.addresses.delete", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.createSnapshot", "compute.disks.delete", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list", "compute.disks.setLabels", "compute.diskTypes.get", "compute.diskTypes.list", "compute.externalVpnGateways.list", "compute.firewalls.get", "compute.firewalls.list", "compute.images.get", "compute.images.list", "compute.images.setLabels", "compute.instances.get", "compute.instanceGroups.create", "compute.instanceGroups.delete", "compute.instanceGroups.get", "compute.instanceGroups.list", "compute.instances.get", "compute.instances.list", "compute.instances.setLabels", "compute.instances.start", "compute.instances.stop", "compute.instances.update", "compute.instanceTemplates.create", "compute.instanceTemplates.delete", "compute.instanceTemplates.get", "compute.instanceTemplates.getIamPolicy", "compute.instanceTemplates.list", "compute.interconnects.get", "compute.machineTypes.get", "compute.machineTypes.list", "compute.networkEndpointGroups.get", "compute.networks.get", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.reservations.get", "compute.reservations.list", "compute.reservations.list", "compute.routers.list", "compute.routes.get", "compute.securityPolicies.get", "compute.snapshots.get", "compute.snapshots.setLabels", "compute.sslPolicies.list", "compute.subnetworks.list", "compute.targetHttpProxies.get", "compute.targetPools.get", "compute.vpnGateways.list", "compute.zones.get", "compute.zones.list", "compute.disks.resize", "compute.instances.delete", "container.clusters.get", "container.clusters.list", "dataflow.jobs.list", "dns.managedZones.get", "dns.managedZones.list", "file.backups.list", "file.instances.list", "file.locations.list", "iam.serviceAccounts.get", "logging.sinks.create", "logging.sinks.delete", "logging.sinks.get", "logging.sinks.list", "logging.sinks.update", "logging.views.list", "monitoring.alertPolicies.create", "monitoring.alertPolicies.delete", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.alertPolicies.update", "monitoring.dashboards.get", "monitoring.dashboards.list", "monitoring.groups.get", "monitoring.groups.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.monitoredResourceDescriptors.get", "monitoring.monitoredResourceDescriptors.list", "monitoring.notificationChannelDescriptors.get", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.timeSeries.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "recommender.cloudsqlIdleInstanceRecommendations.get", "recommender.cloudsqlIdleInstanceRecommendations.list", "recommender.cloudsqlOverprovisionedInstanceRecommendations.get", "recommender.cloudsqlOverprovisionedInstanceRecommendations.list", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.get", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.list", "recommender.computeAddressIdleResourceRecommendations.get", "recommender.computeAddressIdleResourceRecommendations.list", "recommender.computeDiskIdleResourceRecommendations.get", "recommender.computeDiskIdleResourceRecommendations.list", "recommender.computeImageIdleResourceRecommendations.get", "recommender.computeImageIdleResourceRecommendations.list", "recommender.computeInstanceIdleResourceRecommendations.get", "recommender.computeInstanceIdleResourceRecommendations.list", "recommender.computeInstanceMachineTypeRecommendations.get", "recommender.computeInstanceMachineTypeRecommendations.list", "recommender.spendBasedCommitmentRecommendations.get", "recommender.spendBasedCommitmentRecommendations.list", "recommender.usageCommitmentRecommendations.get", "recommender.usageCommitmentRecommendations.list", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.containerthreatdetectionsettings.update", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.update", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.update", "securitycenter.securitycentersettings.get", "securitycenter.securitycentersettings.update", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.securityhealthanalyticssettings.update", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.subscription.get", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.virtualmachinethreatdetectionsettings.update", "securitycenter.websecurityscannersettings.get", "securitycenter.websecurityscannersettings.update", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
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

