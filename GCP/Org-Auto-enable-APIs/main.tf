provider "google" {
  project = var.project_id
}

data "google_project" "current" {}

# ---------- Enable required deploy-time APIs ----------
# (In the SEED project only)
resource "google_project_service" "apis" {
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "run.googleapis.com",
    "pubsub.googleapis.com",
    "cloudscheduler.googleapis.com",
    "firestore.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudbuild.googleapis.com",
    "eventarc.googleapis.com"
  ])
  project = var.project_id
  service = each.key
}

# ---------- Firestore (Native) for state ----------
resource "google_firestore_database" "default" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.location_id
  type        = "FIRESTORE_NATIVE"
}

# ---------- Service Account ----------
resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = "sa-project-autoconfig"
  display_name = "Org Project Auto-config"
}

# ---------- Org-level IAM for SA ----------
resource "google_organization_iam_member" "viewer" {
  org_id = var.org_id
  role   = "roles/resourcemanager.projectViewer"
  member = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_organization_iam_member" "serviceusage_admin" {
  org_id = var.org_id
  role   = "roles/serviceusage.serviceUsageAdmin"
  member = "serviceAccount:${google_service_account.sa.email}"
}

# ---------- Pub/Sub topic ----------
resource "google_pubsub_topic" "topic" {
  name    = "org-project-scan"
  project = var.project_id
}

# ---------- Package function code ----------
data "archive_file" "function_zip" {
  type        = "zip"
  output_path = "${path.module}/function.zip"
  source_dir  = "${path.module}/function"
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "google_storage_bucket" "code" {
  name                        = "${var.project_id}-functions-code-${random_id.suffix.hex}"
  project                     = var.project_id
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
}

resource "google_storage_bucket_object" "zip" {
  name   = "org-project-autoconfig/${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.code.name
  source = data.archive_file.function_zip.output_path
}

# ---------- Cloud Function (2nd gen) w/ Pub/Sub trigger ----------
resource "google_cloudfunctions2_function" "function" {
  name     = "org-project-autoconfig"
  location = var.region

  build_config {
    runtime     = "python311"
    entry_point = "entrypoint"

    source {
      storage_source {
        bucket = google_storage_bucket.code.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    available_memory      = "256M"
    timeout_seconds       = 60
    service_account_email = google_service_account.sa.email
    environment_variables = {
      ORG_ID           = var.org_id
      STATE_COLLECTION = var.state_collection
      STATE_DOC        = var.state_doc
    }
    ingress_settings = "ALLOW_INTERNAL_AND_GCLB"
  }

  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.topic.id
    retry_policy   = "RETRY_POLICY_RETRY"
  }

  depends_on = [
    google_project_service.apis,
    google_firestore_database.default
  ]
}

# Allow Pub/Sub service agent to invoke (via Eventarc)
resource "google_project_iam_member" "eventarc_sa_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# ---------- Cloud Scheduler job ----------
resource "google_cloud_scheduler_job" "daily" {
  name        = "daily-org-scan"
  schedule    = var.scheduler_cron
  time_zone   = var.scheduler_time_zone
  description = "Publish a message daily to trigger org project API enablement for new projects"

  pubsub_target {
    topic_name = google_pubsub_topic.topic.id
    data       = base64encode("run")
  }

  depends_on = [google_cloudfunctions2_function.function]
}
