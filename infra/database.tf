resource "google_sql_database_instance" "postgres" {
  name             = "hackathon-postgres-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_15"
  region           = "us-central1"
  depends_on       = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    
    ip_configuration {
      ssl_mode = "ENCRYPTED_ONLY" 
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
    
    # Constraint: customConstraints/custom.SQLenforcePassword
    password_validation_policy {
      enable_password_policy      = true # Constraint: customConstraints/custom.SQLenforcePassword
      min_length                  = 12 # Constraint: customConstraints/custom.SQLpasswordMinLength
      complexity                  = "COMPLEXITY_DEFAULT" # Constraint: customConstraints/custom.SQLpasswordComplexity
      disallow_username_substring = true # Constraint: customConstraints/custom.SQLdisallowUsernameSubstring
      password_change_interval    = "900s" # Example interval
      reuse_interval              = 10 # Constraint: customConstraints/custom.SQLPasswordreUseInterval
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
  password = "S1ng4p0r3*26" # Should be a variable/secret in realprod
}

resource "google_bigquery_dataset" "analytics" {
  dataset_id                  = "hackathon_analytics"
  friendly_name               = "Hackathon Analytics"
  description                 = "Dataset for Hackathon analytics"
  location                    = "us-central1"
}
