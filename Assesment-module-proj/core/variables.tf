variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}
variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "assign_role" {
  type = set(string)
  description = "Assign Role"
  default = ["viewer"]
  nullable = true
}

variable "role_id" {
type = string
default = null
nullable = true  
}
variable "permissionsec" {
  type = string
  description = "secops check"
  nullable = true
  default = null
}
variable "permission_full" {
  type = set(string)
  description = "All permissions"
  default = ["appengine.applications.get", "appengine.instances.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list", "bigquery.datasets.get", "bigquery.jobs.get", "bigquery.jobs.list", "bigquery.reservations.get", "bigquery.reservations.list", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudiot.registries.get", "cloudiot.registries.list", "cloudsecurityscanner.scans.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "composer.environments.list", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list", "compute.disks.setLabels", "compute.diskTypes.get", "compute.diskTypes.list", "compute.externalVpnGateways.list", "compute.firewalls.get", "compute.firewalls.list", "compute.images.get", "compute.images.list", "compute.images.setLabels", "compute.instances.get", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.reservations.get", "compute.reservations.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "dns.managedZones.get", "dns.managedZones.list", "iam.serviceAccounts.get", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.timeSeries.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "recommender.cloudsqlIdleInstanceRecommendations.get", "recommender.cloudsqlIdleInstanceRecommendations.list", "recommender.cloudsqlOverprovisionedInstanceRecommendations.get", "recommender.cloudsqlOverprovisionedInstanceRecommendations.list", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.get", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.list", "recommender.computeAddressIdleResourceRecommendations.get", "recommender.computeAddressIdleResourceRecommendations.list", "recommender.computeDiskIdleResourceRecommendations.get", "recommender.computeDiskIdleResourceRecommendations.list", "recommender.computeImageIdleResourceRecommendations.get", "recommender.computeImageIdleResourceRecommendations.list", "recommender.computeInstanceIdleResourceRecommendations.get", "recommender.computeInstanceIdleResourceRecommendations.list", "recommender.computeInstanceMachineTypeRecommendations.get", "recommender.computeInstanceMachineTypeRecommendations.list", "recommender.spendBasedCommitmentRecommendations.get", "recommender.spendBasedCommitmentRecommendations.list", "recommender.usageCommitmentRecommendations.get", "recommender.usageCommitmentRecommendations.list", "resourcemanager.projects.get", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.securitycentersettings.get", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.websecurityscannersettings.get", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}

variable "permission_nosecops" {
  type = set(string)
  description = "Permissons without secops"
  default =  ["appengine.applications.get", "appengine.instances.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list", "bigquery.datasets.get", "bigquery.jobs.get", "bigquery.jobs.list", "bigquery.reservations.get", "bigquery.reservations.list", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudiot.registries.get", "cloudiot.registries.list", "cloudsecurityscanner.scans.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "composer.environments.list", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list", "compute.disks.setLabels", "compute.diskTypes.get", "compute.diskTypes.list", "compute.externalVpnGateways.list", "compute.firewalls.get", "compute.firewalls.list", "compute.images.get", "compute.images.list", "compute.images.setLabels", "compute.instances.get", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.reservations.get", "compute.reservations.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "dns.managedZones.get", "dns.managedZones.list", "iam.serviceAccounts.get", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.timeSeries.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "recommender.cloudsqlIdleInstanceRecommendations.get", "recommender.cloudsqlIdleInstanceRecommendations.list", "recommender.cloudsqlOverprovisionedInstanceRecommendations.get", "recommender.cloudsqlOverprovisionedInstanceRecommendations.list", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.get", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.list", "recommender.computeAddressIdleResourceRecommendations.get", "recommender.computeAddressIdleResourceRecommendations.list", "recommender.computeDiskIdleResourceRecommendations.get", "recommender.computeDiskIdleResourceRecommendations.list", "recommender.computeImageIdleResourceRecommendations.get", "recommender.computeImageIdleResourceRecommendations.list", "recommender.computeInstanceIdleResourceRecommendations.get", "recommender.computeInstanceIdleResourceRecommendations.list", "recommender.computeInstanceMachineTypeRecommendations.get", "recommender.computeInstanceMachineTypeRecommendations.list", "recommender.spendBasedCommitmentRecommendations.get", "recommender.spendBasedCommitmentRecommendations.list", "recommender.usageCommitmentRecommendations.get", "recommender.usageCommitmentRecommendations.list", "resourcemanager.projects.get", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]

}
variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com", "sqladmin.googleapis.com", "monitoring.googleapis.com", "pubsub.googleapis.com"]
}

