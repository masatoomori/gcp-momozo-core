# Static Website Configuration
# Google Cloud Storage bucket for static website hosting

# Create the storage bucket for the website
resource "google_storage_bucket" "website" {
  name          = var.domain_name
  location      = "ASIA"
  storage_class = "STANDARD"

  # Enable website configuration
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  # Enable uniform bucket-level access
  uniform_bucket_level_access = true

  # Enable versioning for content updates
  versioning {
    enabled = true
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

# Upload index.html
resource "google_storage_bucket_object" "index_html" {
  name         = "index.html"
  bucket       = google_storage_bucket.website.name
  source       = "${path.root}/../../public/index.html"
  content_type = "text/html"

  # Generate MD5 hash to detect changes
  detect_md5hash = filemd5("${path.root}/../../public/index.html")
}

# Upload 404.html
resource "google_storage_bucket_object" "not_found_html" {
  name         = "404.html"
  bucket       = google_storage_bucket.website.name
  source       = "${path.root}/../../public/404.html"
  content_type = "text/html"

  # Generate MD5 hash to detect changes
  detect_md5hash = filemd5("${path.root}/../../public/404.html")
}

