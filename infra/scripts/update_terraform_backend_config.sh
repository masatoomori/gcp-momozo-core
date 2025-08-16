#!/bin/bash

# Ensure the necessary environment variables are set
if [[ -z "$TERRAFORM_STATE_BUCKET" || -z "$TERRAFORM_STATE_PREFIX" ]]; then
    echo "Error: TERRAFORM_STATE_BUCKET or TERRAFORM_STATE_PREFIX environment variable is not set."
    exit 1
fi

# Define the file to modify
FILE="../terraform/state.tf"

# Replace placeholders in the file using sed
sed -i '' "s|<terraform-state-bucket>|$TERRAFORM_STATE_BUCKET|g" "$FILE"
sed -i '' "s|<terraform-state-prefix>|$TERRAFORM_STATE_PREFIX|g" "$FILE"

echo "Replaced placeholders in $FILE with environment variable values."
