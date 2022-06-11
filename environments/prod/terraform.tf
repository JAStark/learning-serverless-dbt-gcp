terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~>4.22.0"
    }
  }
  backend "gcs" {
    bucket = "severless-dbt-tfstate"
    prefix = "env/prod"
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
  region  = var.region

}

resource "google_artifact_registry_repository" "prod-serverless-dbt-repo"     {
  provider      = google-beta

  project       = var.project_id
  location      = var.region
  repository_id = "prod-serverless-dbt-example"
  description   = "tf-created repo for serverless dbt example"
  format        = "DOCKER"
}

# resource "google_service_account" "prod_dbt_serverless_workflow_account" {
#   account_id    = "prod-workflows-demo-account"
#   display_name  = "PROD DBT Workflows Demo Account"
# }
#
# resource "google_service_account_iam_binding" "prod_dbt_workflows_run_iam" {
#   service_account_id = google_service_account.prod_dbt_serverless_workflow_account.name
#   role               = "roles/run.invoker"
#
#   members = [
#     "serviceAccount:prod_workflows_account@silver-antonym-326607.iam.gserviceaccount.com",
#   ]
# }
#
# resource "google_service_account_iam_binding" "prod_dbt_workflows_workflows_iam" {
#   service_account_id = google_service_account.prod_dbt_serverless_workflow_account.name
#   role               = "roles/workflows.invoker"
#
#   members = [
#     "serviceAccount:prod_workflows_account@silver-antonym-326607.iam.gserviceaccount.com",
#   ]
# }

resource "google_workflows_workflow" "prod_dbt_demo_workflow" {
  name            = "prod_dbt_serverless_workflow_demo"
  region          = "europe-west1"
  description     = "PROD demo workflow for cloud run, and dbt w/ snowflake"
  service_account = google_service_account.prod_dbt_serverless_workflow_account.id
  # source_contents = file("workflow.yaml")
  source_contents = <<-EOF
  - dbt_cloud_run_1_task:
      call: http.get
      args:
        url: https://prod-serverless-dbt-example-jrek4srhha-ew.a.run.app
        auth:
          type: OIDC
  - return_result:
      return: "all done"

      EOF
}
