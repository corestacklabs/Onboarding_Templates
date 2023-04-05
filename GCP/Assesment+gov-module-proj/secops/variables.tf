variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}


variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
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
  default = ["compute.disks.list", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "resourcemanager.projects.get", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.containerthreatdetectionsettings.update", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.update", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.update", "securitycenter.securitycentersettings.get", "securitycenter.securitycentersettings.update", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.securityhealthanalyticssettings.update", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.virtualmachinethreatdetectionsettings.update", "securitycenter.websecurityscannersettings.get", "securitycenter.websecurityscannersettings.update", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}

variable "permission_nosecops" {
  type = set(string)
  description = "Permissons with no secops"
  default = ["compute.disks.list", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "resourcemanager.projects.get", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}
variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com"]
}

