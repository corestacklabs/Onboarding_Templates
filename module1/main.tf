terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
  project = var.project_id
}

resource "google_project_iam_custom_role" "my_custom_proj_role" {
  role_id     = var.role_id
  project     = var.project_id 
  title       = "Corestack-gcp-custom-role-test"
  description = "Custom role for the corestack gcp module"
  permissions = ["storage.objects.list", "storage.objects.get", "storage.buckets.list", "storage.buckets.get", "compute.regions.get", "compute.regions.list", "compute.zones.get", "compute.zones.list", "resourcemanager.projects.get", "resourcemanager.projects.list"]
}
resource "google_project_iam_binding" "role-binding" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/${google_project_iam_custom_role.my_custom_proj_role.role_id}"
  members = ["serviceAccount:${google_service_account.service_account.email}"]
}

resource "google_storage_bucket" "bucket" {
  name          = var.new_bucket_name
  location      = var.bucket_location
  project =  var.project_id
}

# Resource for Query1
resource "google_bigquery_data_transfer_config" "query_config_1"{
      display_name           = "corestack-daily-query"
      project                = var.project_id
      location               = "${var.dataset_location}"
      data_source_id         = "scheduled_query"
      schedule               = "every 24 hours"
      params = {
        query = "DECLARE unused STRING; DECLARE current_month_date DATE DEFAULT DATE_SUB(@run_date, INTERVAL 0 MONTH); DECLARE cost_data_invoice_month NUMERIC DEFAULT EXTRACT(MONTH FROM current_month_date); DECLARE cost_data_invoice_year NUMERIC DEFAULT EXTRACT(YEAR FROM current_month_date); EXPORT DATA OPTIONS ( uri = CONCAT('gs://${var.new_bucket_name}/', CAST(cost_data_invoice_year AS STRING), '-', CAST(current_month_date AS STRING FORMAT('MM')), '/', CAST(DATE(CURRENT_DATE()) as STRING FORMAT('YYYY-MM-DD')), '/*.csv'), format='JSON', overwrite=False) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.dataset_id}` as B WHERE B.invoice.month = CONCAT(CAST(cost_data_invoice_year AS STRING), CAST(current_month_date AS STRING FORMAT('MM'))) AND B.cost != 0.0"
      }
    }

# Resource for Query2
resource "google_bigquery_data_transfer_config" "query_config_2"{
      display_name           = "corestack-monthly-query"
      project                = var.project_id
      location               = "${var.dataset_location}"
      data_source_id         = "scheduled_query"
      schedule               = "5 of month 00:00"
      params = {
        query = "DECLARE unused STRING; DECLARE current_month_date DATE DEFAULT DATE_SUB(@run_date, INTERVAL 1 MONTH); DECLARE cost_data_invoice_month NUMERIC DEFAULT EXTRACT(MONTH FROM current_month_date); DECLARE cost_data_invoice_year NUMERIC DEFAULT EXTRACT(YEAR FROM current_month_date); EXPORT DATA OPTIONS ( uri = CONCAT('gs://${var.new_bucket_name}/', CAST(cost_data_invoice_year AS STRING), '-', CAST(current_month_date AS STRING FORMAT('MM')), '_backfill/*.csv'), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.dataset_id}` as B WHERE B.invoice.month = CONCAT(CAST(cost_data_invoice_year AS STRING), CAST(current_month_date AS STRING FORMAT('MM'))) AND B.cost != 0.0"


      }
    }

# Resource for Query3
resource "google_bigquery_data_transfer_config" "query_config_3"{
      display_name           = "corestack-on-demand"
      project                = var.project_id
      location               = "${var.dataset_location}"
      data_source_id         = "scheduled_query"
      schedule               = "None"
      params = {
        query = "DECLARE unused STRING; DECLARE current_month_date DATE DEFAULT DATE_SUB(@run_date, INTERVAL 1 MONTH); DECLARE cost_data_invoice_month NUMERIC DEFAULT EXTRACT(MONTH FROM current_month_date); DECLARE cost_data_invoice_year NUMERIC DEFAULT EXTRACT(YEAR FROM current_month_date); EXPORT DATA OPTIONS ( uri = CONCAT('gs://${var.new_bucket_name}/', CAST(cost_data_invoice_year AS STRING), '-', CAST(current_month_date AS STRING FORMAT('MM')), '/*.csv'), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.dataset_id}` as B WHERE B.invoice.month = CONCAT(CAST(cost_data_invoice_year AS STRING), CAST(current_month_date AS STRING FORMAT('MM'))) AND B.cost != 0.0"
      }
    }

# Resource for Query4
resource "google_bigquery_data_transfer_config" "query_config_4"{
      display_name           = "corestack-on-demand"
      project                = var.project_id
      location               = "${var.dataset_location}"
      data_source_id         = "scheduled_query"
      schedule               = "None"
      params = {
        query = "DECLARE unused STRING; DECLARE current_month_date DATE DEFAULT DATE_SUB(@run_date, INTERVAL 2 MONTH); DECLARE cost_data_invoice_month NUMERIC DEFAULT EXTRACT(MONTH FROM current_month_date); DECLARE cost_data_invoice_year NUMERIC DEFAULT EXTRACT(YEAR FROM current_month_date); EXPORT DATA OPTIONS ( uri = CONCAT('gs://${var.new_bucket_name}/', CAST(cost_data_invoice_year AS STRING), '-', CAST(current_month_date AS STRING FORMAT('MM')), '/*.csv'), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.dataset_id}` as B WHERE B.invoice.month = CONCAT(CAST(cost_data_invoice_year AS STRING), CAST(current_month_date AS STRING FORMAT('MM'))) AND B.cost != 0.0"
      }
    }

# Resource for Query5
resource "google_bigquery_data_transfer_config" "query_config_5"{
      display_name           = "corestack-on-demand"
      project                = var.project_id
      location               = "${var.dataset_location}"
      data_source_id         = "scheduled_query"
      schedule               = "None"
      params = {
        query = "DECLARE unused STRING; DECLARE current_month_date DATE DEFAULT DATE_SUB(@run_date, INTERVAL 3 MONTH); DECLARE cost_data_invoice_month NUMERIC DEFAULT EXTRACT(MONTH FROM current_month_date); DECLARE cost_data_invoice_year NUMERIC DEFAULT EXTRACT(YEAR FROM current_month_date); EXPORT DATA OPTIONS ( uri = CONCAT('gs://${var.new_bucket_name}/', CAST(cost_data_invoice_year AS STRING), '-', CAST(current_month_date AS STRING FORMAT('MM')), '/*.csv'), format='JSON', overwrite=True) AS SELECT *, (SELECT STRING_AGG(display_name, '/') FROM B.project.ancestors) organization_list FROM `${var.dataset_id}` as B WHERE B.invoice.month = CONCAT(CAST(cost_data_invoice_year AS STRING), CAST(current_month_date AS STRING FORMAT('MM'))) AND B.cost != 0.0"
      }     
        
}
