# Service Accounts
resource "google_service_account" "sa_frontend" {
  account_id   = "sa-frontend"
  display_name = "Frontend Service Account"
}

resource "google_service_account" "sa_backend" {
  account_id   = "sa-backend"
  display_name = "Backend Service Account"
}

resource "google_service_account" "sa_pytools" {
  account_id   = "sa-pytools"
  display_name = "Python Tools Service Account"
}

# Placeholder Services to establish identity and IAM
resource "google_cloud_run_service" "backend" {
  name     = "backend-service"
  location = "us-central1"

  template {
    spec {
      service_account_name = google_service_account.sa_backend.email
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image,
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
    ]
  }
}

resource "google_cloud_run_service" "frontend" {
  name     = "frontend-service"
  location = "us-central1"

  template {
    spec {
      service_account_name = google_service_account.sa_frontend.email
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image,
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
    ]
  }
}

resource "google_cloud_run_service" "pytools" {
  name     = "pytools-service"
  location = "us-central1"

  template {
    spec {
      service_account_name = google_service_account.sa_pytools.email
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image,
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
    ]
  }
}

# IAM Bindings
# Frontend can invoke Backend
resource "google_cloud_run_service_iam_binding" "backend_invoker" {
  location = google_cloud_run_service.backend.location
  service  = google_cloud_run_service.backend.name
  role     = "roles/run.invoker"
  members  = [
    "serviceAccount:${google_service_account.sa_frontend.email}"
  ]
}

# Backend can invoke Python Tools
resource "google_cloud_run_service_iam_binding" "pytools_invoker" {
  location = google_cloud_run_service.pytools.location
  service  = google_cloud_run_service.pytools.name
  role     = "roles/run.invoker"
  members  = [
    "serviceAccount:${google_service_account.sa_backend.email}"
  ]
}

# Allow unrestricted access to Frontend (Public)
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth_frontend" {
  location    = google_cloud_run_service.frontend.location
  project     = google_cloud_run_service.frontend.project
  service     = google_cloud_run_service.frontend.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

# Database Access
resource "google_project_iam_member" "backend_sql_client" {
  project = element(split("/", google_cloud_run_service.backend.project), 1) // hack to get project id if needed or just var
  # Using project from data or var usually better but this works if resource exists
  # Actually better to start with "google_project" data source
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sa_backend.email}"
}

resource "google_project_iam_member" "pytools_sql_client" {
  project = google_cloud_run_service.backend.project 
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.sa_pytools.email}"
}
