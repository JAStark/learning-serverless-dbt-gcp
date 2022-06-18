resource "google_cloudbuild_trigger" "dev-serverless-dbt-cloud-run-2-build-trigger" {
  name        = "dev-serverless-dbt-cloud-run-2-build-trigger"
  description = "DEV Cloud build trigger to rebuild Docker container for cloud run 2"
  github {
    owner = "JAStark"
    name  = "learning-serverless-dbt-gcp"
    push {
      branch = "^dev$"
    }
  }

  included_files = ["dbt_cloud_run_2/**"]
  filename       = "dbt_cloud_run_2/cloudbuild.yaml"

}
