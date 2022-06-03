terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
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
