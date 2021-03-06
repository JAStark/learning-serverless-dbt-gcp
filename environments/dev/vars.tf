variable "project_id" {
  type    = string
  default = "silver-antonym-326607"
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "service_account_id" {
  default = "dev-dbt-workflows-invoker"
}

variable "service_account_email" {
  default = "dev-dbt-workflows-invoker@silver-antonym-326607.iam.gserviceaccount.com"
}
