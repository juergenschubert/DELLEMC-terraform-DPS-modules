variable "ddve_name" {}
variable "ami_filtername" {
  default = "ddve-7.3.0.5-663138-GA-3cc6672f-1de3-47d6-8eb2-31f9ebd815c7-ami-002eeb5ba32bd2e9d.4"
}
variable "region" {}
variable "instance_type" {}
variable "aws-subnet-id" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "security_group_id" {}

#find the latest DDVE image in your region
data "aws_ami" "ddve6" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
 #   values = ["ddve-7.3.0.5-663138-GA-3cc6672f-1de3-47d6-8eb2-31f9ebd815c7-ami-002eeb5ba32bd2e9d.4"]
    values = [var.ami_filtername]
  }
}

resource "aws_instance" "terraform_ddve" {
  ami = data.aws_ami.ddve6.id
  #  ami           = lookup(var.ami_id, var.region)
  instance_type = var.instance_type
  # subnet the instance runs into
  subnet_id = var.aws-subnet-id
  # key name
  key_name = var.key_name

  # Security group assign to instance
  vpc_security_group_ids = [var.security_group_id]
  # tighten things up with the instance profile
  iam_instance_profile = var.iam_instance_profile
  ### delete associated ec2 disks
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    Name = var.ddve_name
  }
}

output "public_ipv4" {
    value = aws_instance.terraform_ddve.public_ip
}
output "ec2_id" {
     value = aws_instance.terraform_ddve.id
}
output "public_v4_ip" {
  value = aws_instance.terraform_ddve.public_ip
}