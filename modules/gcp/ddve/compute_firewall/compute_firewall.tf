
locals {
  ingress_rules = [
    {
      protocol    = "tcp"
      ports       = 443
      name        = "Port for https"
      source_tags = ["ddve"]
    },
    {
      protocol    = "tcp"
      ports       = 80
      name        = "Port for http"
      source_tags = ["ddve"]
    },
    {
      protocol    = "tcp"
      ports       = 22
      name        = "Port for ssh"
      source_tags = ["ddve"]
    },
    {
      protocol    = "tcp"
      ports       = 3009
      name        = "Port for ddve ReST"
      source_tags = ["ddve"]
    },
    {
      protocol    = "tcp"
      ports       = 2049
      name        = "Port for DD Boost and replication"
      source_tags = ["ddve"]
    },
    {
      protocol    = "tcp"
      ports       = 2051
      name        = "Port for DD Boost and replication"
      source_tags = ["ddve"]
    }
  ]
}

resource "google_compute_firewall" "terraform_firewall" {
  name    = var.firewall_name
  network = var.network_name
  project = var.gcp_project_id

  allow {
    protocol = "icmp"
  }

  source_tags = ["ddve"]

}

resource "google_compute_firewall" "terraform_firewall_1" {
  name    = var.ddve_firewall_name
  network = var.network_name
  project = var.gcp_project_id
  dynamic "allow" {
    for_each = local.ingress_rules
    content {
      protocol = allow.value.protocol
      ports    = [allow.value.ports]
    }
  }
}
