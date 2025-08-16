#!/bin/bash

# Set necessary variables
PROJECT_ID=$GOOGLE_CLOUD_PROJECT
BUCKET_NAME="$TERRAFORM_STATE_BUCKET"
REGION=$TERRAFORM_STATE_REGION
STORAGE_CLASS="STANDARD"  # Modify as needed (e.g., "NEARLINE")

# Check if the bucket already exists
if gsutil ls -b "gs://$BUCKET_NAME" > /dev/null 2>&1; then
    echo "Cloud Storage bucket '$BUCKET_NAME' already exists."
else
    # Create the bucket
    gsutil mb -p "$PROJECT_ID" -c "$STORAGE_CLASS" -l "$REGION" "gs://$BUCKET_NAME"
    echo "Cloud Storage bucket '$BUCKET_NAME' created."
fi

# Enable versioning (recommended for state files)
gsutil versioning set on "gs://$BUCKET_NAME"
echo "Versioning enabled for bucket '$BUCKET_NAME'."
