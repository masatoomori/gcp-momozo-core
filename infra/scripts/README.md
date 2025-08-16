# Infrastructure Setup for Terraform

This repository contains scripts and configurations necessary for setting up the infrastructure using Terraform.

## Prerequisites

Before running Terraform, you need to perform the following steps using the provided shell scripts:

1. **Create Cloud Storage Bucket for Terraform State Management**

   - **Script**: `create_terraform_state_bucket.sh`
   - **Description**: This script creates a Google Cloud Storage bucket to store Terraform state files.
   - **Usage**:

     ```bash
     ./create_terraform_state_bucket.sh
     ```

   - **Environment Variables**:
     - `GOOGLE_CLOUD_PROJECT`: The ID of your Google Cloud project.
     - `TERRAFORM_STATE_BUCKET`: The name of the Cloud Storage bucket for Terraform state.
     - `TERRAFORM_STATE_PREFIX`: The prefix to be used for Terraform state files.

1. **Update Terraform Backend Configuration**

   - **Script**: `update_terraform_backend_config.sh`
   - **Description**: This script updates the `state.tf` file with the environment variable values for the bucket and prefix.
   - **Usage**:

     ```bash
     ./update_terraform_backend_config.sh
     ```

   - **Environment Variables**:
     - `TERRAFORM_STATE_BUCKET`: The name of the Cloud Storage bucket for Terraform state.
     - `TERRAFORM_STATE_PREFIX`: The prefix to be used for Terraform state files.

## Steps to Run

1. Set the environment variables in the `.envrc` file located at the root of the project. The contents of the `.envrc` file should look like this:

   ```bash
   export GOOGLE_CLOUD_PROJECT="your-google-cloud-project-id"
   export TERRAFORM_STATE_BUCKET="your-terraform-state-bucket-name"
   export TERRAFORM_STATE_PREFIX="your-terraform-state-prefix"
   ```

1. Load the environment variables by navigating to the project directory and running:

   ```bash
   direnv allow
   ```

1. Run the script to create the Cloud Storage bucket:

   ```bash
   ./create_terraform_state_bucket.sh
   ```

1. Update the Terraform backend configuration:

   ```bash
   ./update_terraform_backend_config.sh
   ```

1. Proceed with Terraform commands to initialize and apply your infrastructure configuration:

   ```bash
   terraform init
   terraform apply
   ```
