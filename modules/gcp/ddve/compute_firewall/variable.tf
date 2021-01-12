variable "network_name" {}
variable "firewall_name" {
  default = "terraform-allow-icmp"
}
variable gcp_project_id {}
variable "ddve_firewall_name" {
  default = "terraform-ddve-access"
}