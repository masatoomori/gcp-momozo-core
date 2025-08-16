terraform {
  backend "gcs" {
    bucket = "momozo-core-tfstate"
    prefix = "gcp-momozo-core"
  }
}
