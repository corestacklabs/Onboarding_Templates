variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}


variable "org_id" {
  type = string
  description = "Organization ID"
}
variable "permissionsec" {
  type = string
  default = null
  nullable = true
  description = "permissons secops check"
}

variable "permission_full" {
  type = set(string)
  description = "Full permissons"
  default = ["compute.disks.list", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.securitycentersettings.get", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.subscription.get", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.websecurityscannersettings.get", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list", "compute.networks.get"]
}

variable "permission_nosecops" {
  type = set(string)
  description = "Permissons with no secops"
  default = ["compute.disks.list", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list", "compute.networks.get"]
}
variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com"]
}

