resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
  project                 = var.gcp_project_id  
}

resource "google_compute_subnetwork" "main" {
  name          = var.subnet_name
  project       = var.gcp_project_id  
  ip_cidr_range = var.subnet_cidr_block
  region        = var.subnet_region
  network       = var.compute_network_id
  }

output "network_ID" {
  value       = google_compute_network.main.id
  }
output "network_name" {
  value = google_compute_network.main.name
}
output "subnet_name" {
  value = google_compute_subnetwork.main.name
}