resource "google_cloudbuild_trigger" "prod-serverless-dbt-cloud-run-1-build-trigger" {
  name            = "prod-serverless-dbt-cloud-run-1-build-trigger"
  description     = "PROD Cloud build trigger to rebuild Docker container for cloud run 1"
  region          = var.region
  github {
    owner         = "JAStark"
    name          = "learning-serverless-dbt-gcp"
    push {
      branch      = "^prod$"
      }
  }

  included_files  = ["dbt-cloud-run-1/**"]
  filename        = "dbt-cloud-run-1/cloudbuild.yaml"

}
