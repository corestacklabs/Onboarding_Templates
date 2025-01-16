terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
locals {
  bucket_name = "corestack-${var.project_id}"
  api = ["compute.googleapis.com","cloudresourcemanager.googleapis.com", "cloudbilling.googleapis.com", "recommender.googleapis.com"]
}
resource "google_service_account" "service_account" {
  account_id   = "corestack-auth"
  display_name = "corestack-auth"
  project = var.project_id
}

resource "google_project_iam_custom_role" "my_custom_proj_role" {
  role_id     = "corestackAuthRole"
  project     = var.project_id 
  title       = "Corestack-gcp-custom-role-test"
  description = "Custom role for the corestack gcp module"
  permissions = ["storage.objects.list", "storage.objects.get", "storage.buckets.list", "storage.buckets.get", "compute.regions.get", "compute.regions.list", "compute.zones.get", "compute.zones.list", "resourcemanager.projects.get"]
}
resource "google_project_iam_binding" "role-binding" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/${google_project_iam_custom_role.my_custom_proj_role.role_id}"
  members = ["serviceAccount:${google_service_account.service_account.email}"]
}

resource "google_storage_bucket" "bucket" {
  name          = local.bucket_name
  location      = var.bucket_location
  project =  var.project_id
  uniform_bucket_level_access = true
}

# Resource for Query1
resource "google_bigquery_data_transfer_config" "query_config_1"{
      display_name           = "corestack-daily-query-${var.project_id}"
      project                = var.project_id
      location               = "${var.bucket_location}"
      data_source_id         = "scheduled_query"
      schedule               = "every 24 hours"
      params = {
        query = "DECLARE bucket_name STRING DEFAULT '${local.bucket_name}'; DECLARE current_date DATE DEFAULT CURRENT_DATE; DECLARE start_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(current_date, MONTH), 'US/Pacific'); DECLARE end_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_ADD(current_date, INTERVAL 1 MONTH), MONTH), 'US/Pacific'); DECLARE bucket_path STRING DEFAULT CONCAT('gs://', bucket_name, '/', FORMAT_DATE('%G-%m', current_date), '/', FORMAT_DATE('%F', current_date), '/*.csv'); EXPORT DATA OPTIONS (uri=(bucket_path), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.table_id}` as B WHERE usage_start_time >= start_date AND usage_start_time < end_date AND _PARTITIONTIME >= TIMESTAMP(EXTRACT(DATE FROM start_date)) ;"
      }
    }

# Resource for Query2
resource "google_bigquery_data_transfer_config" "query_config_2"{
      display_name           = "corestack-monthly-query-${var.project_id}"
      project                = var.project_id
      location               = "${var.bucket_location}"
      data_source_id         = "scheduled_query"
      schedule               = "5 of month 00:00"
      params = {
        query = "DECLARE bucket_name STRING DEFAULT '${local.bucket_name}'; DECLARE current_date DATE DEFAULT CURRENT_DATE; DECLARE start_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_SUB(current_date, INTERVAL 1 MONTH), MONTH), 'US/Pacific'); DECLARE end_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_ADD(EXTRACT(DATE FROM start_date), INTERVAL 1 MONTH), MONTH), 'US/Pacific'); DECLARE bucket_path STRING DEFAULT CONCAT('gs://', bucket_name, '/', FORMAT_TIMESTAMP('%G-%m', start_date), '_backfill/*.csv'); EXPORT DATA OPTIONS (uri=(bucket_path), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.table_id}` as B WHERE usage_start_time >= start_date AND usage_start_time < end_date AND _PARTITIONTIME >= TIMESTAMP(EXTRACT(DATE FROM start_date)) ;"


      }
    }

# Resource for Query3
resource "google_bigquery_data_transfer_config" "query_config_3"{
      display_name           = "corestack-on-demand-1-${var.project_id}"
      project                = var.project_id
      location               = "${var.bucket_location}"
      data_source_id         = "scheduled_query"
      schedule               = "None"
      params = {
        query = ""
      }
    }

# Resource for Query4
resource "google_bigquery_data_transfer_config" "query_config_4"{
      display_name           = "corestack-on-demand-2-${var.project_id}"
      project                = var.project_id
      location               = "${var.bucket_location}"
      data_source_id         = "scheduled_query"
      schedule               = "None"
      params = {
        query = "DECLARE bucket_name STRING DEFAULT '${local.bucket_name}'; DECLARE current_date DATE DEFAULT CURRENT_DATE; DECLARE start_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_SUB(current_date, INTERVAL 2 MONTH), MONTH), 'US/Pacific'); DECLARE end_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_ADD(EXTRACT(DATE FROM start_date), INTERVAL 1 MONTH), MONTH), 'US/Pacific'); DECLARE bucket_path STRING DEFAULT CONCAT('gs://', bucket_name, '/', FORMAT_TIMESTAMP('%G-%m', start_date), '_backfill/*.csv'); EXPORT DATA OPTIONS (uri=(bucket_path), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.table_id}` as B WHERE usage_start_time >= start_date AND usage_start_time < end_date AND _PARTITIONTIME >= TIMESTAMP(EXTRACT(DATE FROM start_date)) ;"
      }
    }

# Resource for Query5
resource "google_bigquery_data_transfer_config" "query_config_5"{
      display_name           = "corestack-on-demand-3-${var.project_id}"
      project                = var.project_id
      location               = "${var.bucket_location}"
      data_source_id         = "scheduled_query"
      schedule               = "None"
      params = {
        query = "DECLARE bucket_name STRING DEFAULT '${local.bucket_name}'; DECLARE current_date DATE DEFAULT CURRENT_DATE; DECLARE start_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_SUB(current_date, INTERVAL 3 MONTH), MONTH), 'US/Pacific'); DECLARE end_date TIMESTAMP DEFAULT TIMESTAMP(DATE_TRUNC(DATE_ADD(EXTRACT(DATE FROM start_date), INTERVAL 1 MONTH), MONTH), 'US/Pacific'); DECLARE bucket_path STRING DEFAULT CONCAT('gs://', bucket_name, '/', FORMAT_TIMESTAMP('%G-%m', start_date), '_backfill/*.csv'); EXPORT DATA OPTIONS (uri=(bucket_path), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.table_id}` as B WHERE usage_start_time >= start_date AND usage_start_time < end_date AND _PARTITIONTIME >= TIMESTAMP(EXTRACT(DATE FROM start_date)) ;"
      }     
        
}

resource "google_project_service" "api_proj_enabler" {
    project = var.project_id
    for_each = var.api
    service = each.value
}
