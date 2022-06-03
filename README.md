# learning-serverless-dbt-gcp
Trying Robert Sahlin's blog post https://robertsahlin.com/serverless-dbt-on-google-cloud-platform/
Note that the workflows code and the cloud build triggers were build from within the console, and are therefore not represented here in the repo.


[EDIT]
Having completed the above blog post, I'm not sure I'd want to run DBT using Cloud Build, as this can quickly become unreadable YAML. At work, we're toying with the idea of running DBT from a Cloud Run instance. Therefore this next iteration of this project with try that approach.

In addition, the Cloud Build triggers will not be used going forward, so they will be deleted from the GCP project.
The Workflows code will be also be removed from the project for the time being as it refers specifically to the triggers and therefore can not generalise as it currently is to anything else.


# Architecture
- Cloud Schedular to trigger start of pipeline
- _or_ GCS bucket `update` trigger to trigger start of pipeline ... could both be implemented at the same time?!
- Workflows to orchestrate:
  - really just to poll a GCS bucket for if all files are there yet
  - once files are there, to trigger `Cloud Run 1` which will do a basic DBT thing and write a table to snowflake.
- `Cloud Run 1` will complete and trigger `Cloud Run 2` and `Cloud Run 3` and write 2 other tables to snowflake.
- Alerting and Monitoring will be set up such that alerts get sent to a slack channel with nice instructions
- all infrastructure is set up with Terraform where appropriate/possible
