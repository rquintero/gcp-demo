resource "google_service_account" "cloudbuild_sa" {
  account_id   = "sa-cloudbuild"
  display_name = "Cloud Build Service Account"
}

# Grant Cloud Build SA permissions
resource "google_project_iam_member" "cloudbuild_editor" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

resource "google_project_iam_member" "cloudbuild_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# Artifact Registry Writer
resource "google_artifact_registry_repository_iam_member" "build_ar_writer" {
  project    = google_artifact_registry_repository.repo.project
  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# --- Backend Trigger ---
resource "google_cloudbuild_trigger" "backend_trigger" {
  name        = "backend-trigger"
  description = "Trigger for Backend Service"
  location = "us-central1"
  
  # Note: This assumes you have connected the repo manually or via other means.
  # If using 2nd Gen Repositories, the config is different.
  # For 1st Gen (mirrored):
  github {
    owner = "rquintero"
    name  = "gcp-demo"
    push {
      branch = "^main$"
    }
  }

  included_files = ["backend/**"]
  
  service_account = google_service_account.cloudbuild_sa.id

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/backend:latest", "."]
      dir  = "backend"
    }
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/backend:latest"]
    }
    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = ["run", "deploy", "backend-service", "--image", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/backend:latest", "--region", var.region]
    }
  }
}

# --- Frontend Trigger ---
resource "google_cloudbuild_trigger" "frontend_trigger" {
  name        = "frontend-trigger"
  description = "Trigger for Frontend Service"
  location = "us-central1"

  github {
    owner = "rquintero"
    name  = "gcp-demo"
    push {
      branch = "^main$"
    }
  }

  included_files = ["frontend/**"]
  
  service_account = google_service_account.cloudbuild_sa.id

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/frontend:latest", "."]
      dir  = "frontend"
    }
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/frontend:latest"]
    }
    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = ["run", "deploy", "frontend-service", "--image", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/frontend:latest", "--region", var.region]
    }
  }
}

# --- Python Tools Trigger ---
resource "google_cloudbuild_trigger" "pytools_trigger" {
  name        = "pytools-trigger"
  description = "Trigger for Python Tools Service"
  location = "us-central1"

  github {
    owner = "rquintero"
    name  = "gcp-demo"
    push {
      branch = "^main$"
    }
  }

  included_files = ["python-tools/**"]
  
  service_account = google_service_account.cloudbuild_sa.id

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/pytools:latest", "."]
      dir  = "python-tools"
    }
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/pytools:latest"]
    }
    step {
      name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
      entrypoint = "gcloud"
      args = ["run", "deploy", "pytools-service", "--image", "${google_artifact_registry_repository.repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/pytools:latest", "--region", var.region]
    }
  }
}
