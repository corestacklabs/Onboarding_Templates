#!/bin/bash

# Array of project IDs 
PROJECT_IDS=(
#add project ID here as a string comma seprated values.
)

# Array of APIs to enable 
APIS_TO_ENABLE=(
  "cloudresourcemanager.googleapis.com"
  "compute.googleapis.com"
  "recommender.googleapis.com"
  "securitycenter.googleapis.com"
  "orgpolicy.googleapis.com"
  "sqladmin.googleapis.com"
  "monitoring.googleapis.com"
  "pubsub.googleapis.com"
)

# Loop over each project ID
for PROJECT_ID in "${PROJECT_IDS[@]}"
do
  echo "✨ Processing project: $PROJECT_ID"
  
  for API in "${APIS_TO_ENABLE[@]}"
  do
    echo "🌐 Enabling API $API for project $PROJECT_ID..."
    
    gcloud services enable "$API" --project="$PROJECT_ID"

    if [ $? -eq 0 ]; then
      echo "✅ Successfully enabled $API for $PROJECT_ID."
    else
      echo "⚠️ Failed to enable $API for $PROJECT_ID." >&2
    fi
  done

  echo "--------------------------------------"
done

echo "🎉 All operations completed."
