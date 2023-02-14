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
  permissions = ["logging.sinks.create", "logging.sinks.delete", "logging.sinks.get", "logging.sinks.list", "logging.sinks.update", "monitoring.notificationChannels.create", "monitoring.notificationChannels.delete", "monitoring.notificationChannels.get", "monitoring.notificationChannels.list", "monitoring.notificationChannels.update", "monitoring.alertPolicies.create", "monitoring.alertPolicies.delete", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.alertPolicies.update", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "pubsub.subscriptions.create", "pubsub.subscriptions.delete", "pubsub.subscriptions.get", "pubsub.subscriptions.list", "pubsub.subscriptions.update", "pubsub.topics.attachSubscription", "pubsub.topics.create", "pubsub.topics.delete", "pubsub.topics.get", "pubsub.topics.list", "pubsub.topics.publish", "pubsub.topics.update", "pubsub.topics.detachSubscription", "pubsub.topics.getIamPolicy", "pubsub.topics.setIamPolicy", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.sources.update", "securitycenter.subscription.get", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.rapidvulnerabilitydetectionsettings.update", "securitycenter.securitycentersettings.get", "securitycenter.securitycentersettings.update", "securitycenter.securityhealthanalyticssettings.calculate", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.securityhealthanalyticssettings.update", "securitycenter.sources.get", "storage.buckets.create", "storage.buckets.delete", "storage.buckets.get", "storage.buckets.list", "storage.buckets.update", "storage.objects.get", "storage.objects.list", "iam.roles.get", "iam.roles.list", "resourcemanager.organizations.get", "resourcemanager.organizations.getIamPolicy", "serviceusage.services.disable", "serviceusage.services.enable", "resourcemanager.projects.getIamPolicy", "resourcemanager.folders.get", "resourcemanager.projects.get", "resourcemanager.projects.list", "compute.zones.list", "compute.zones.get", "billing.budgets.list", "billing.budgets.get", "billing.budgets.createstorage.buckets.get", "billing.budgets.create", "billing.budgets.update", "iam.roles.get", "iam.roles.list", "recommender.iamPolicyInsights.get", "recommender.iamPolicyInsights.list", "recommender.iamPolicyLateralMovementInsights.get", "recommender.iamPolicyLateralMovementInsights.list", "recommender.iamPolicyRecommendations.get", "recommender.iamPolicyRecommendations.list", "recommender.iamPolicyRecommendations.update", "compute.reservations.get", "compute.reservations.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.metricDescriptors.get", "storage.buckets.getIamPolicy"]
}
# resource for assigning the custom role to the service account 
resource "google_organization_iam_member" "binding_custom_role" {
  org_id = var.org_id
  role   = "organizations/${var.org_id}/roles/${var.role_id}"
  member = "serviceAccount:${var.service_account_email}"
}

# Collector tile for making the project list
output "list_proj" {
  description = "Project List"
  value = data.google_projects.my-org-projects.projects
}

# Resource to execute the python script that will enable the apis. 
resource "null_resource" "Project_script" {
 provisioner "local-exec" {  
    command = "/bin/python3 extractor.py"
  }
}

