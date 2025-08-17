# Website outputs
output "website_url" {
  description = "URL of the static website"
  value       = "https://storage.googleapis.com/${google_storage_bucket.website.name}/index.html"
}

output "website_bucket_url" {
  description = "Direct bucket URL for website access"
  value       = "https://${google_storage_bucket.website.name}.storage.googleapis.com"
}

output "bucket_name" {
  description = "Name of the storage bucket hosting the website"
  value       = google_storage_bucket.website.name
}

output "domain_name" {
  description = "Configured domain name"
  value       = var.domain_name
}

