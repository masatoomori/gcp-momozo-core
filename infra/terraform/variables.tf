variable "project_id" {
  type        = string
  description = "Google Cloud Project ID declared in .envrc"
  default     = "momozo-core"
}

variable "region" {
  type        = string
  description = "Default Google Cloud region declared in .envrc"
  default     = "asia-northeast1"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the website"
  default     = "momozo-inn.com"
}
