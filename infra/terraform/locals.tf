locals {
  env        = "dev" # dev / stg / prod
  www_domain = "www.${var.domain_name}"
}
