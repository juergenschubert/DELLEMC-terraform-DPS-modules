resource "google_compute_disk" "nvram" {
  name    = "nvram"
  project = var.gcp_project_id
  type    = "pd-ssd"
  zone    = "${var.gcp_region}-b"
  size    = 10
}

resource "google_compute_disk" "metadatadisk" {
  count   = var.amount_of_metadisk
  project = var.gcp_project_id
  name    = "metadatadisk-${count.index}"
  # name  = element(var.meta_disk_device_names, count.index)
  type = "pd-ssd"
  zone = "${var.gcp_region}-b"
  size = var.metadisksize_GB
}

output "nvram_self_link" {
  value = google_compute_disk.nvram.self_link
}
