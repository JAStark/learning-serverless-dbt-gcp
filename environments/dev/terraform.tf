terraform {
  required_providers {
    google    = {
      source  = "hashicorp/google"
      version = "~>4.22.0"
    }
  }
  backend "gcs" {
    bucket = "severless-dbt-tfstate"
    prefix = "env/dev"
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.region

}

resource "google_artifact_registry_repository" "dev-serverless-dbt-repo"     {
  provider      = google-beta

  project       = var.project_id
  location      = var.region
  repository_id = "dev-serverless-dbt-example"
  description   = "tf-created repo for serverless dbt example"
  format        = "DOCKER"
}

# resource "google_service_account" "dev_dbt_serverless_workflow_account" {
#   account_id    = "dev-workflows-demo-account"
#   display_name  = "DEV DBT Workflows Demo Account"
# }
#
# resource "google_service_account_iam_binding" "dev_dbt_workflows_run_iam" {
#   service_account_id = google_service_account.dev_dbt_serverless_workflow_account.name
#   role               = "roles/run.invoker"
#
#   members = [
#     "serviceAccount:dev_workflows_account@silver-antonym-326607.iam.gserviceaccount.com",
#   ]
# }
#
# resource "google_service_account_iam_binding" "dev_dbt_workflows_workflows_iam" {
#   service_account_id = google_service_account.dev_dbt_serverless_workflow_account.name
#   role               = "roles/workflows.invoker"
#
#   members = [
#     "serviceAccount:dev_workflows_account@silver-antonym-326607.iam.gserviceaccount.com",
#   ]
# }

resource "google_service_account" "dbt_serverless_workflow_account" {
  account_id    = "scheduler-workflows-invoke"
  display_name  = "DEV DBT Workflows Demo Account"
}

resource "google_workflows_workflow" "dev_dbt_demo_workflow" {
  name            = "dev_dbt_serverless_workflow_demo"
  region          = "europe-west1"
  description     = "DEV demo workflow for cloud run, and dbt w/ snowflake"
  service_account = google_service_account.dbt_serverless_workflow_account.id
  # source_contents = file("workflow.yaml")
  source_contents = <<-EOF
  - dbt_cloud_run_1_task:
      call: http.get
      args:
        url: https://dev-serverless-dbt-example-jrek4srhha-ew.a.run.app
        auth:
          type: OIDC
      result: response

      EOF
}


data "google_service_account" "dbt_serverless_workflow_account" {}

resource "google_cloud_scheduler_job" "dev-dbt-workflows-job" {
  name              = "dev-dbt-serverless-workflows-job"
  description       = "trigger DEV workflow once per day"
  schedule          = "0 9 * * *"
  time_zone         = "Europe/London"
  attempt_deadline  = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "https://workflowexecutions.googleapis.com/v1/projects/${PROJECT_ID}/locations/europe-west1/workflows/dev_dbt_serverless_workflow_demo/executions"

    oauth_token {
      service_account_email = data.google_service_account.dbt_serverless_workflow_account.email
    }
  }
}
