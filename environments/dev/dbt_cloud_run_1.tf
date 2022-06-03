resource "google_cloudbuild_trigger" "dev-serverless-dbt-cloud-run-1-build-trigger" {
  name            = "dev-serverless-dbt-cloud-run-1-build-trigger"
  description     = "DEV Cloud build trigger to rebuild Docker container for cloud run 1"
  region          = var.region 
  github {
    owner         = "JAStark"
    name          = "learning-serverless-dbt-gcp"
    push {
      branch      = "^dev$"
      }
  }

  included_files  = ["dbt-cloud-run-1/**"]
  filename        = "dbt-cloud-run-1/cloudbuild.yaml"

}
