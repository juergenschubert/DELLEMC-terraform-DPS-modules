resource "google_storage_bucket" "main" {
  name          = var.bucket_name
  location      = var.bucket_region
  force_destroy = true
  project       = var.gcp_project_id
  storage_class = "REGIONAL"
}
output "bucket_name" {
  value = google_storage_bucket.main.name
}
