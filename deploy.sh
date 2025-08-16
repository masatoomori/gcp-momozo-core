#!/bin/bash

# Deploy script for Momozo Inn website
# This script helps deploy the static website to Google Cloud Storage using Terraform

set -e  # Exit on any error

echo "🍑 Momozo Inn Website Deployment Script"
echo "========================================"

# Check if we're in the right directory
if [[ ! -f "website/index.html" ]]; then
    echo "❌ Error: website/index.html not found. Please run this script from the repository root."
    exit 1
fi

# Navigate to terraform directory
cd infra/terraform

echo "📋 Checking Terraform configuration..."

# Validate Terraform configuration
if terraform validate > /dev/null 2>&1; then
    echo "✅ Terraform configuration is valid"
else
    echo "❌ Terraform configuration validation failed"
    terraform validate
    exit 1
fi

echo "📊 Checking for changes..."
terraform plan -no-color

echo ""
echo "🚀 Ready to deploy!"
echo ""
echo "Next steps:"
echo "1. Review the plan above"
echo "2. If everything looks good, run: terraform apply"
echo "3. After deployment, your website will be available at:"
echo "   - https://storage.googleapis.com/momozo-inn.com/index.html"
echo "   - https://momozo-inn.com.storage.googleapis.com"
echo ""
echo "📝 To update website content:"
echo "1. Edit files in the website/ directory"
echo "2. Run 'terraform apply' to upload changes"
echo ""

read -p "Do you want to proceed with deployment? (y/N): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Deploying website..."
    terraform apply
    echo ""
    echo "✅ Deployment complete!"
    echo "🌐 Your website should now be live at the URLs mentioned above."
else
    echo "⏸️  Deployment cancelled."
fi