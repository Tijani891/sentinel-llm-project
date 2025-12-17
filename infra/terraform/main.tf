provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_project_service" "required" {
  for_each = toset([
    "aiplatform.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "logging.googleapis.com",
    "iam.googleapis.com"
  ])

  project = var.project_id
  service = each.key
  disable_on_destroy = false
}


resource "google_service_account" "sentinel" {
  account_id   = var.service_account_name
  display_name = "Sentinel LLM Service Account"
}

resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.sentinel.email}"
}

resource "google_project_iam_member" "vertex_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.sentinel.email}"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.sentinel.email}"
}


resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.artifact_repo_name
  format        = "DOCKER"
  description   = "Sentinel LLM container images"
}
