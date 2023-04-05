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
  role_id = "pojfinopsa"
}
# resource for making a custom role from the set of permission
resource "google_project_iam_custom_role" "my-custom-role" {
  role_id     = local.role_id
  project = var.project_id
  title       = "custom-role-project-core-a"
  description = "Custom role for the corestack gcp module"
  permissions = ["appengine.applications.get", "appengine.instances.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list", "bigquery.datasets.get", "bigquery.jobs.get", "bigquery.reservations.get", "bigquery.reservations.list", "bigquery.transfers.get", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudiot.registries.get", "cloudiot.registries.list", "cloudscheduler.jobs.list", "cloudsecurityscanner.scans.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "cloudtasks.queues.list", "composer.environments.list", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list", "compute.disks.setLabels", "compute.diskTypes.get", "compute.diskTypes.list", "compute.externalVpnGateways.list", "compute.firewalls.get", "compute.firewalls.list", "compute.images.get", "compute.images.list", "compute.images.setLabels", "compute.instanceGroups.list", "compute.instances.get", "compute.instances.get", "compute.instances.list", "compute.instances.setLabels", "compute.instanceTemplates.get", "compute.interconnects.get", "compute.networkEndpointGroups.get", "compute.networks.get", "compute.networks.list", "compute.regions.get", "compute.regions.list", "compute.routers.list", "compute.routes.get", "compute.securityPolicies.get", "compute.snapshots.get", "compute.snapshots.setLabels", "compute.sslPolicies.list", "compute.targetHttpProxies.get", "compute.targetPools.get", "compute.vpnGateways.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "dataflow.jobs.list", "dns.managedZones.get", "dns.managedZones.list", "file.backups.list", "file.instances.list", "file.locations.list", "iam.roles.list", "iam.serviceAccounts.get", "logging.sinks.delete", "logging.sinks.get", "logging.sinks.list", "logging.sinks.update", "logging.views.list", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.notificationChannels.get", "monitoring.notificationChannels.list", "pubsub.subscriptions.get", "pubsub.subscriptions.getIamPolicy", "pubsub.subscriptions.list", "pubsub.topics.attachSubscription", "pubsub.topics.detachSubscription", "pubsub.topics.get", "pubsub.topics.getIamPolicy", "pubsub.topics.list", "pubsub.topics.publish", "resourcemanager.projects.get", "run.services.list", "spanner.databases.list", "spanner.instances.list", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}
# resource for assigning the custom role to the service account 
resource "google_project_iam_member" "binding_role" {
  project = var.project_id
  role   = "projects/${var.project_id}/roles/${local.role_id}"
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

