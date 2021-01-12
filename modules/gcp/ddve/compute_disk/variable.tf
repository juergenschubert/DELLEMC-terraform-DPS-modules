#mapping values of the volume. So _NVRAM got mapped to /dev/sdc
variable "meta_disk_device_names" {
  default = [
    "/dev/sdc",
    "/dev/sdd",
    "/dev/sde",
    "/dev/sdf",
    "/dev/sdg",
    "/dev/sdh",
    "/dev/sdi",
    "/dev/sdj",
    "/dev/sdk",
    "/dev/sdl",
    "/dev/sdm",
    "/dev/sdn",
    "/dev/sdo",
    "/dev/sdp",
    "/dev/sdq",
    "/dev/sdr"
  ]
}
variable "gcp_region" {}
variable "amount_of_metadisk" {}
variable "metadisksize_GB" {}
variable "gcp_project_id" {}  
