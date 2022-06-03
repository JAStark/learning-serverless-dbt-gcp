terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 3.89.0"
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
  region  = "europe-west2"

}

resource "google_artifact_registry_repository" "dev-serverless-dbt-repo"     {
  provider      = google-beta

  project       = var.project_id
  location      = "europe-west1"
  repository_id = "dev-serverless-dbt-example"
  description   = "tf-created repo for serverless dbt example"
  format        = "DOCKER"
}
