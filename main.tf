
locals {
  bill_acc  = "01F0C7-9A2082-488963"
  proj_name = "gcp-billing-analytics"
  proj_id   = "gcp-billing-analytics2"
  region    = "US"
  location  = "us-central1"
}

resource "google_project_service" "cloudbilling_api" {
  project = local.proj_id
  service = "cloudbilling.googleapis.com"
}

resource "google_project_service" "bigquery_api" {
  project = local.proj_id
  service = "bigquery.googleapis.com"
}

resource "google_project_service" "bigquerydatatransfer_api" {
  project            = local.proj_id
  service            = "bigquerydatatransfer.googleapis.com"
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "billing_export_dataset" {
  dataset_id = "billing_dump"
  location   = local.region
  project    = local.proj_id
  depends_on = [google_project_service.bigquery_api]
}

# resource "google_project_iam_member" "billing_export_bigquery_writer" {
#   project = local.proj_id
#   role    = "roles/bigquery.dataEditor"
#   member  = "serviceAccount:billing-export@${local.proj_id}.iam.gserviceaccount.com"
#   depends_on = [google_bigquery_dataset.billing_export_dataset]
# }

# resource "google_billing_budget" "billing_export" {
#   billing_account = local.bill_acc
#   display_name    = "Billing Export to BigQuery"
#   budget_filter {
#     projects = ["projects/${local.proj_id}"]
#   }
#   amount {
#     specified_amount {
#       currency_code = "USD"
#       units         = "1"
#     }
#   }
#   depends_on = [google_project_service.billing_api]
# }

output "billing_dataset_id" {
  value = google_bigquery_dataset.billing_export_dataset.dataset_id
}


