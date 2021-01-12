variable "aws_region" {}
variable "amount_of_metadisk" {}
variable "terraform_aws_instance_id" {}
variable "ebs_volume_metadisk_sizeGB" {}
#mapping values of the volume. So _NVRAM got mapped to /dev/sdc
variable "ec2_device_names" {
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
#create the nvram disk first
resource "aws_ebs_volume" "nvram" {

  availability_zone = l"${var.aws_region}-b"
  size              = 10
  type              = "gp2"
  tags = {
    Name = "_NVRAM"
  }
}
#attach the nvram disk
resource "aws_volume_attachment" "attach_nvram" {
  volume_id   = aws_ebs_volume.nvram.id
  device_name = "/dev/sdb"
  instance_id = var.terraform_aws_instance_id
}
# create the metadatadisk - amount definded in terraform.tfvars
resource "aws_ebs_volume" "ebs_volume" {
  count             = var.amount_of_metadisk
  availability_zone = "${var.aws_region}-b"
  size              = var.ebs_volume_metadisk_sizeGB
  type              = "gp2"
  tags = {
    Name = "metadatadisk-${count.index}"
  }
}
# attach the volume to the instance
resource "aws_volume_attachment" "volume_attachement" {
  count       = var.amount_of_metadisk
  volume_id   = aws_ebs_volume.ebs_volume.*.id[count.index]
  device_name = element(var.ec2_device_names, count.index)
  instance_id = var.terraform_aws_instance_id
}
