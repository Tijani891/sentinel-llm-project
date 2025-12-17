output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "service_account_email" {
  value       = google_service_account.sentinel.email
  description = "Service account for Cloud Run"
}

output "artifact_registry_repo" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo_name}"
}

output "enabled_services" {
  value = [for s in google_project_service.services : s.service]
}
