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

resource "google_service_account" "dbt_serverless_workflow_account" {
  account_id    = "workflows-demos-account"
  display_name  = "DBT Workflows Demo Account"
}

resource "google_workflows_workflow" "dbt_demo_workflow" {
  name            = "dbt_serverless_workflow_demo"
  region          = "europe-west1"
  description     = "demo workflow for cloud run, and dbt w/ snowflake"
  service_account = google_service_account.dbt_serverless_workflow_account.id
  # source_contents = file("workflow.yaml")
  source_contents = <<-EOF
  - dbt_cloud_run_1_task:
      call: http.get
      args:
        url: https://${BRANCH_NAME}-serverless-dbt-example-jrek4srhha-ew.a.run.app
        auth:
          type: OIDC
      #   body:
      #     input: ${log_result.body}
      # result: not_sure
  - return_result:
      return: "all done"

      EOF
}


resource "google_cloud_scheduler_job" "dbt-workflows-job" {
  name              = "dbt-serverless-workflows-job"
  description       = "trigger the workflow once per day"
  schedule          = "0 9 * * *"
  time_zone         = "Europe/London"
  attempt_deadline  = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    # uri = "https://workflowexecutions.googleapis.com/v1/projects/${PROJECT_ID}/locations/europe-west1/workflows/dbt_serverless_workflow_demo/executions"
    uri         = google_workflows_workflow.dbt_demo_workflow.id
  }
}
