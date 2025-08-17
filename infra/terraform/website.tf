# Static Website Configuration
# Google Cloud Storage bucket for static website hosting

# Create the storage bucket for the website
resource "google_storage_bucket" "website" {
  name          = var.domain_name
  location      = "ASIA"
  storage_class = "STANDARD"

  # Enable website configuration
  # Website configuration removed — served by Firebase Hosting instead

  # Enable uniform bucket-level access
  uniform_bucket_level_access = true

  # Versioning disabled (managed via GitHub/Firebase)
  versioning {
    enabled = false
  }

  # Labels for organization
  labels = {
    environment = local.env
    project     = "momozo-core"
    purpose     = "static-website"
  }
}

# Make the bucket publicly readable
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
