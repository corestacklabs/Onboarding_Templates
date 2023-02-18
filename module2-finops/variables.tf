variable "service_account_email" {
  type = string
  description = "email of service account created in module1"
}
variable "project_id" {
  type = string
  description = "List of projects on which the service is going to be enabled"
}

variable "org_id" {
  type = string
  description = "Organization ID"
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

variable "assment_permisson" {
  type = set(string)
  description = "All the permisssion for Assesment"
  default = ["compute.machineTypes.get", "compute.machineTypes.list","billing.budgets.list","billing.budgets.get","storage.objects.list", "storage.objects.get", "storage.buckets.list", "storage.buckets.get", "billing.budgets.create", "billing.budgets.get", "billing.budgets.list", "billing.budgets.update", "iam.roles.get", "iam.roles.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.metricDescriptors.getendations.list", "compute.reservations.list", "compute.zones.get", "compute.zones.list", "compute.regions.get", "compute.regions.list", "compute.instance.get", "compute.instances.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.timeSeries.list", "monitoring.timeSeries.get", "resourcemanager.folders.get", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "compute.addresses.get", "compute.addresses.list", "compute.commitments.get", "compute.commitments.list", "compute.diskTypes.get", "compute.diskTypes.list", "compute.disks.get", "compute.images.list", "compute.reservations.get", "compute.reservations.list", "bigquery.datasets.get", "bigquery.datasets.list", "bigquery.jobs.get", "bigquery.jobs.list", "bigtable.tables.get", "bigtable.tables.list", "bigquery.reservations.get", "bigquery.reservations.list", "recommender.cloudsqlIdleInstanceRecommendations.get", "recommender.cloudsqlIdleInstanceRecommendations.list", "recommender.cloudsqlOverprovisionedInstanceRecommendations.get", "recommender.cloudsqlOverprovisionedInstanceRecommendations.list", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.get", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.list", "recommender.computeAddressIdleResourceRecommendations.get", "recommender.computeAddressIdleResourceRecommendations.list", "recommender.computeDiskIdleResourceRecommendations.get", "recommender.computeDiskIdleResourceRecommendations.list", "recommender.computeImageIdleResourceRecommendations.get", "recommender.computeImageIdleResourceRecommendations.list", "recommender.computeInstanceIdleResourceRecommendations.get", "recommender.computeInstanceIdleResourceRecommendations.list", "recommender.computeInstanceMachineTypeRecommendations.get", "recommender.computeInstanceMachineTypeRecommendations.list", "recommender.spendBasedCommitmentRecommendations.get", "recommender.spendBasedCommitmentRecommendations.list", "recommender.usageCommitmentRecommendations.get", "recommender.usageCommitmentRecommendations.list"]
}

variable "assmentgovpermisson" {
  type = set(string)
  description = "All permission for Assesment + Governace"
  default = ["billing.budgets.list", "billing.budgets.delete", "billing.budgets.create", "billing.budgets.update", "billing.budgets.get","compute.addresses.delete", "compute.disks.delete", "compute.disks.resize", "compute.instances.delete", "compute.instances.update", "compute.machineTypes.get", "compute.machineTypes.list"]
}

variable "role_id" {
  type = string
  description = "Role ID"
}

variable "api" {
    type = set(string)
    description = "List of APIS that needs to be enabled per project"
    default = ["cloudresourcemanager.googleapis.com" ,"compute.googleapis.com","recommender.googleapis.com"]
}

