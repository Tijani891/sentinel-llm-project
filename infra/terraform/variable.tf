variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "service_account_name" {
  description = "Service account name"
  type        = string
  default     = "sentinel-deployer"
}
