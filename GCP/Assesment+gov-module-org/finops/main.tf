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
  roleid = "orgfinopsag"
}
#data collector 
data "google_projects" "my-org-projects" {
  filter = "parent.id:${var.org_id}"
}

# resource for making a custom role from the set of permission
resource "google_organization_iam_custom_role" "my-custom-role" {
  role_id     = local.roleid
  org_id      = var.org_id
  title       = "custom-role-org-finops-ag"
  description = "Custom role for the corestack gcp module"
  permissions = ["appengine.applications.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list", "bigquery.datasets.get", "bigquery.jobs.get", "bigquery.reservations.get", "bigquery.reservations.list", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudiot.registries.get", "cloudiot.registries.list", "cloudsecurityscanner.scans.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "cloudsql.instances.update", "composer.environments.list", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.createSnapshot", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list", "compute.disks.setLabels", "compute.diskTypes.get", "compute.diskTypes.list", "compute.externalVpnGateways.list", "compute.firewalls.get", "compute.firewalls.list", "compute.images.get", "compute.images.list", "compute.images.setLabels", "compute.instances.get", "compute.instanceGroups.create", "compute.instanceGroups.delete", "compute.instanceGroups.get", "compute.instanceGroups.list", "compute.instances.get", "compute.instances.list", "compute.instances.setLabels", "compute.instances.start", "compute.instances.stop", "compute.instanceTemplates.create", "compute.instanceTemplates.delete", "compute.instanceTemplates.get", "compute.instanceTemplates.getIamPolicy", "compute.instanceTemplates.list", "compute.interconnects.get", "compute.machineTypes.get", "compute.machineTypes.list", "compute.networkEndpointGroups.get", "compute.networks.get", "compute.networks.list", "compute.regions.get", "compute.regions.list", "compute.reservations.get", "compute.reservations.list", "compute.routers.list", "compute.routes.get", "compute.securityPolicies.get", "compute.snapshots.get", "compute.snapshots.setLabels", "compute.sslPolicies.list", "compute.targetHttpProxies.get", "compute.targetPools.get", "compute.vpnGateways.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "dataflow.jobs.list", "dns.managedZones.get", "dns.managedZones.list", "file.backups.list", "file.instances.list", "file.locations.list", "iam.serviceAccounts.get", "logging.sinks.create", "logging.sinks.delete", "logging.sinks.get", "logging.sinks.list", "logging.sinks.update", "logging.views.list", "monitoring.alertPolicies.create", "monitoring.alertPolicies.delete", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.alertPolicies.update", "monitoring.dashboards.get", "monitoring.dashboards.list", "monitoring.groups.get", "monitoring.groups.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.monitoredResourceDescriptors.list", "monitoring.notificationChannelDescriptors.get", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list", "pubsub.subscriptions.create", "pubsub.subscriptions.delete", "pubsub.subscriptions.get", "pubsub.subscriptions.list", "pubsub.subscriptions.update", "pubsub.topics.attachSubscription", "pubsub.topics.create", "pubsub.topics.delete", "pubsub.topics.detachSubscription", "pubsub.topics.get", "pubsub.topics.list", "pubsub.topics.publish", "pubsub.topics.update", "pubsub.subscriptions.getIamPolicy", "pubsub.subscriptions.setIamPolicy", "pubsub.topics.getIamPolicy", "pubsub.topics.setIamPolicy"]
}
# resource for assigning the custom role to the service account 
resource "google_organization_iam_member" "binding_custom_role" {
  org_id = var.org_id
  role   = "organizations/${var.org_id}/roles/${local.roleid}"
  member = "serviceAccount:${var.service_account_email}"
  depends_on = [
    google_organization_iam_custom_role.my-custom-role
  ]
}

# Collector tile for making the project list

# Resource to execute the python script that will enable the apis. 
resource "null_resource" "Project_script" {
 provisioner "local-exec" {  
    command = "/bin/python3 extractor.py"
  }
  depends_on = [
    google_organization_iam_member.binding_custom_role
  ]
}

