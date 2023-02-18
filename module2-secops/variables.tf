variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}

variable "type" {
  default = "Assesment"
  description = "Select Assesment or Governance+assesments"
  type = string
  validation {
    condition = contains(["Assesment","Governance+assesments"],var.type)
    error_message = "Select from only this 2: Select Assesment or Governance+assesments"
  }
}
variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "org_id" {
  type = string
  description = "Organization ID"
}

variable "role_id" {
  type = string
  description = "Role ID"
}

variable "assment_permisson" {
  type = set(string)
  description = "All the permisssion for Assesment"
  default = ["securitycenter.assets.group", "securitycenter.assets.list", "securitycenter.assets.listAssetPropertyNames", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.muteconfigs.get", "securitycenter.muteconfigs.list", "securitycenter.notificationconfig.get", "securitycenter.notificationconfig.list", "securitycenter.organizationsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.calculate", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.securitycentersettings.get", "securitycenter.securityhealthanalyticssettings.calculate", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.subscription.get","orgpolicy.constraints.list", "orgpolicy.customConstraints.get", "orgpolicy.customConstraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get"]
}

variable "assmentgovpermisson" {
  type = set(string)
  description = "All permission for Assesment + Governace"
  default = ["securitycenter.assets.group", "securitycenter.assets.list", "securitycenter.assets.listAssetPropertyNames", "securitycenter.assets.runDiscovery", "securitycenter.assetsecuritymarks.update", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.update", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.findings.update", "securitycenter.findingsecuritymarks.update", "securitycenter.muteconfigs.delete", "securitycenter.muteconfigs.get", "securitycenter.muteconfigs.list", "securitycenter.muteconfigs.update", "securitycenter.notificationconfig.delete", "securitycenter.notificationconfig.get", "securitycenter.notificationconfig.list", "securitycenter.notificationconfig.update", "securitycenter.organizationsettings.get", "securitycenter.organizationsettings.update", "securitycenter.rapidvulnerabilitydetectionsettings.calculate", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.update", "securitycenter.securitycentersettings.get", "securitycenter.securitycentersettings.update", "securitycenter.securityhealthanalyticssettings.calculate", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.securityhealthanalyticssettings.update", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.sources.update", "securitycenter.subscription.get","orgpolicy.constraints.list", "orgpolicy.customConstraints.get", "orgpolicy.customConstraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get","orgpolicy.policy.set"]
}

variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com", "securitycenter.googleapis.com", "orgpolicy.googleapis.com"]
}

