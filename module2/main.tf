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

#data collector 
data "google_projects" "my-org-projects" {
  filter = "parent.id:809866736880"
}

# resource for making a custom role from the set of permission
resource "google_organization_iam_custom_role" "my-custom-role" {
  role_id     = var.role_id
  org_id      = var.org_id
  title       = "Corestack-gcp-custom-role-test"
  description = "Custom role for the corestack gcp module"
  permissions = ["logging.sinks.create", "logging.sinks.delete", "logging.sinks.get", "logging.sinks.list", "logging.sinks.update", "monitoring.notificationChannels.create", "monitoring.notificationChannels.delete", "monitoring.notificationChannels.get", "monitoring.notificationChannels.list", "monitoring.notificationChannels.update", "monitoring.alertPolicies.create", "monitoring.alertPolicies.delete", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.alertPolicies.update", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "pubsub.subscriptions.create", "pubsub.subscriptions.delete", "pubsub.subscriptions.get", "pubsub.subscriptions.list", "pubsub.subscriptions.update", "pubsub.topics.attachSubscription", "pubsub.topics.create", "pubsub.topics.delete", "pubsub.topics.get", "pubsub.topics.list", "pubsub.topics.publish", "pubsub.topics.update", "pubsub.topics.detachSubscription", "pubsub.topics.getIamPolicy", "pubsub.topics.setIamPolicy", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.sources.update", "securitycenter.subscription.get", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.update", "securitycenter.securitycentersettings.get", "securitycenter.securitycentersettings.update", "securitycenter.securityhealthanalyticssettings.calculate", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.securityhealthanalyticssettings.update", "securitycenter.sources.get", "storage.buckets.create", "storage.buckets.delete", "storage.buckets.get", "storage.buckets.list", "storage.buckets.update", "storage.objects.get", "storage.objects.list", "iam.roles.get", "iam.roles.list", "resourcemanager.organizations.get", "resourcemanager.organizations.getIamPolicy", "serviceusage.services.disable", "serviceusage.services.enable", "resourcemanager.projects.getIamPolicy", "resourcemanager.folders.get", "resourcemanager.projects.get", "resourcemanager.projects.list", "compute.zones.list", "compute.zones.get", "billing.budgets.list", "billing.budgets.get", "storage.buckets.get", "billing.budgets.create", "billing.budgets.update", "recommender.iamPolicyInsights.get", "recommender.iamPolicyInsights.list", "recommender.iamPolicyLateralMovementInsights.get", "recommender.iamPolicyLateralMovementInsights.list", "recommender.iamPolicyRecommendations.get", "recommender.iamPolicyRecommendations.list", "recommender.iamPolicyRecommendations.update", "compute.reservations.get", "compute.reservations.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.metricDescriptors.get", "storage.buckets.getIamPolicy","bigquery.datasets.get", "bigquery.jobs.get", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.diskTypes.get", "compute.diskTypes.list", "compute.disks.createSnapshot", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list","compute.firewalls.get", "compute.firewalls.list","compute.images.get", "compute.images.list","monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.dashboards.get", "monitoring.dashboards.list", "monitoring.groups.get", "monitoring.groups.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.monitoredResourceDescriptors.list", "monitoring.notificationChannelDescriptors.get", "monitoring.notificationChannelDescriptors.list", "monitoring.notificationChannels.get", "monitoring.notificationChannels.list", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.timeSeries.list","appengine.applications.get", "appengine.instances.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list"]
}
# resource for assigning the custom role to the service account 
resource "google_organization_iam_member" "binding_custom_role" {
  org_id = var.org_id
  role   = "organizations/${var.org_id}/roles/${var.role_id}"
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

