#!/bin/sh
echo "Start Execution\n"
# cd into_dbt_folder?
dbt debug --profiles-dir .
dbt seed --profiles-dir .
dbt run --target=unit-test --profiles-dir .
dbt test --target=unit-test --profiles-dir .
dbt run --target=dev --profiles-dir .
echo "-------------------------------- DONE -----------------------------------"
