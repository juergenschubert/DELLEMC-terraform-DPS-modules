resource "google_compute_instance" "default" {
  machine_type   = "custom-${var.cpu}-${var.mem}"
  name           = var.instance_name
  zone           = var.instance_zone
  can_ip_forward = true

  tags = [ "allow-http", "allow-https", "ssh"]

  boot_disk {
    initialize_params {
      #    image = "${google_compute_image.ddve.Image_ID}"
      #    image = "projects/project-js-286916/global/images/ddve6-ddos7405"
      image = var.ddve_image_ID
    }
  }
  attached_disk {
    #   source = "${google_compute_disk.nvram.self_link}"
    #    source = "projects/project-js-286916/zones/europe-west3-b/disks/nvram"
    source = var.nvram_self_link
  }
  network_interface {
    #    network = "${google_compute_network.vpc_network.name}"
    #    network = "terraform-ddve-network"
    network    = var.network_name
    subnetwork = var.subnet_name
    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_attached_disk" "vm_attached_disk" {
  count    = var.amount_of_metadisk
  disk     = "metadatadisk-${count.index}"
  instance = google_compute_instance.default.self_link
}

output "Instance_ID" {
  value = google_compute_instance.default.instance_id
}
output "public_v4_ip" {
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  #value = "10.0.0.0"
}
