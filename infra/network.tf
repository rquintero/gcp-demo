resource "google_compute_network" "vpc" {
  name                    = "hackathon-vpc"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.apis]
}

# Subnet for Cloud Run (Connector)
resource "google_compute_subnetwork" "serverless_subnet" {
  name          = "serverless-subnet"
  ip_cidr_range = "10.0.0.0/28"
  region        = "us-central1"
  network       = google_compute_network.vpc.id
}

# Subnet for General/Data if needed, or just rely on private service access for SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# VPC Access Connector for Cloud Run to talk to SQL
resource "google_vpc_access_connector" "connector" {
  name          = "vpc-conn"
  subnet {
    name = google_compute_subnetwork.serverless_subnet.name
  }
  region = "us-central1"
  machine_type = "e2-micro"
  min_instances = 2
  max_instances = 3
}
