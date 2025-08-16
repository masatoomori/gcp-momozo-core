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
  source       = "${path.root}/../../website/index.html"
  content_type = "text/html"

  # Generate MD5 hash to detect changes
  detect_md5hash = filemd5("${path.root}/../../website/index.html")
}

# Upload 404.html
resource "google_storage_bucket_object" "not_found_html" {
  name         = "404.html"
  bucket       = google_storage_bucket.website.name
  source       = "${path.root}/../../website/404.html"
  content_type = "text/html"

  # Generate MD5 hash to detect changes
  detect_md5hash = filemd5("${path.root}/../../website/404.html")
}

# Serve www subdomain via HTTPS Load Balancer with Managed SSL
# Backend bucket using the same storage bucket
resource "google_compute_backend_bucket" "website_backend" {
  name        = "${local.env}-website-backend"
  bucket_name = google_storage_bucket.website.name
}

# URL map to direct requests to the backend bucket
resource "google_compute_url_map" "website_map" {
  name            = "${local.env}-website-map"
  default_service = google_compute_backend_bucket.website_backend.id
}

# Managed SSL certificate for www domain
resource "google_compute_managed_ssl_certificate" "www_cert" {
  name = "${local.env}-www-cert"
  managed {
    domains = [local.www_domain]
  }
}

# Target HTTPS proxy using the managed cert and URL map
resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "${local.env}-https-proxy"
  url_map          = google_compute_url_map.website_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.www_cert.id]
}

# Global forwarding rule to accept HTTPS traffic
resource "google_compute_global_address" "lb_ip" {
  name = "${local.env}-lb-ip"
}

resource "google_compute_global_forwarding_rule" "https_forwarding" {
  name        = "${local.env}-https-forwarding"
  ip_address  = google_compute_global_address.lb_ip.address
  ip_protocol = "TCP"
  port_range  = "443"
  target      = google_compute_target_https_proxy.https_proxy.id
}
