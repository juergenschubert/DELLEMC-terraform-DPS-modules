resource "google_compute_image" "main" {
  name = var.image_name
  family = var.image_familiy
  project = var.gcp_project_id
  raw_disk {
    source =  var.image_source
    }
}

output "Image_ID" {
  value       = google_compute_image.main.id
  }