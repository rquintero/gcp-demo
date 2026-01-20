resource "google_artifact_registry_repository" "repo" {
  location      = "us-central1"
  repository_id = "hackathon-repo"
  description   = "Docker repository for Hackathon services"
  format        = "DOCKER"
}
