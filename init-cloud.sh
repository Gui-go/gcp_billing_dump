#!/bin/bash

# chmod +x init-cloud.sh

# gcloud resetting:
echo "Resetting gcloud configurations..."
gcloud config unset compute/region
gcloud config unset project
gcloud config unset billing/quota_project
gcloud auth application-default revoke --quiet

# gcloud auth:
# These credentials will be used by any library that requests Application Default Credentials (ADC).
gcloud auth login --quiet
gcloud auth application-default login --quiet

# Variables:
if [[ -f .env ]]; then
  set -o allexport; source .env; set +o allexport
else
  echo "Error: .env file not found"
  exit 1
fi

# GCP setting:
gcloud projects create $PROJ_ID --name=$PROJ_NAME --labels=owner=guilhermeviegas --enable-cloud-apis --quiet
gcloud beta billing projects link $PROJ_ID --billing-account=$BILLING_ACC
gcloud config set project $PROJ_ID
gcloud config set billing/quota_project $PROJ_ID
gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJ_ID
gcloud auth application-default set-quota-project $PROJ_ID --quiet
gcloud config list



 
terraform init
# terraform workspace new $WORKSPACE_NAME
# terraform workspace select $WORKSPACE_NAME
terraform plan




