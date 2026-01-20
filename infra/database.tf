resource "google_sql_database_instance" "postgres" {
  name             = "hackathon-postgres-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = "us-central1"
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }
  deletion_protection = false # For hackathon/demo purposes
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database" "database" {
  name     = "app-db"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "users" {
  name     = "app-user"
  instance = google_sql_database_instance.postgres.name
  password = "changeme123" # Should be a variable/secret in realprod
}

resource "google_bigquery_dataset" "analytics" {
  dataset_id                  = "hackathon_analytics"
  friendly_name               = "Hackathon Analytics"
  description                 = "Dataset for Hackathon analytics"
  location                    = "US"
}
