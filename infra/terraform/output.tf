output "service_account_email" {
  value = google_service_account.sentinel.email
}

output "enabled_services" {
  value = [for s in google_project_service.services : s.service]
}
