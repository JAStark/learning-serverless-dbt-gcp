terraform {
  required_providers {
    google = {
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
