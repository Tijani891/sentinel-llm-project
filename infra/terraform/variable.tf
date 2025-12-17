variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Primary GCP region"
  type        = string
  default     = "us-central1"
}

variable "service_account_name" {
  description = "Service account ID (no domain)"
  type        = string
  default     = "sentinel-llm-sa"
}

variable "artifact_repo_name" {
  description = "Artifact Registry repository name"
  type        = string
  default     = "sentinel-repo"
}
