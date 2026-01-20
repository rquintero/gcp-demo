# Vertex AI IAM
# Grant User role to Backend and PyTools

resource "google_project_iam_member" "backend_vertex_user" {
  project = google_cloud_run_service.backend.project
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.sa_backend.email}"
}

resource "google_project_iam_member" "pytools_vertex_user" {
  project = google_cloud_run_service.pytools.project
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.sa_pytools.email}"
}

# Grant BigQuery permissions if needed
resource "google_project_iam_member" "backend_bq_user" {
  project = google_cloud_run_service.backend.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.sa_backend.email}"
}

resource "google_project_iam_member" "backend_bq_job_user" {
  project = google_cloud_run_service.backend.project
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.sa_backend.email}"
}
