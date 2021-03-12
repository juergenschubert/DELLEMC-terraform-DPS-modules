provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

#create the needed permissions for usage of S3 with a iam role and policy
module "iam_creation" {
  source = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/ddve/ver6/iam?ref=main"
  iam_role_name         = "iam_role_ddve6_terraform"
  iam_policy_name       = "s3_ddve_iam_policy_ddve6_terraform"
  instance_profile_name = "instance_profile_terraform"
}
#create the s3-buckt for storing data from the ddve
#when changing s3_bucktename make sure to also change within the ddvepolicy.json
module "s3_bucket" {
  source = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/ddve/ver6/s3_bucket?ref=main"
  s3_bucket_name = "ddve6-bucket-terraform"
}

#create the needed security group... firewall
module "ddve_firewall" {
  source = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/ddve/ver6/security_group?ref=main"
  security_group_name = "ddve6_sg_terraform-js"
}
#here we create a Elastic IP resource
resource "aws_eip" "lb" {
  instance = module.aws_instance.ec2_id
  vpc      = true
  tags = {
    Name = "ddve_eip"
  }
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.aws_instance.ec2_id
  allocation_id = aws_eip.lb.id
}

#create the ddve ec2 instance
module "aws_instance" {
  source = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/ddve/ver6/aws_instance-v2?ref=main"
  ddve_name            = "ddve-terraform"
  ami_id               = "ami-0b29b44df5b9a210b"
  aws_region               = var.aws_region
  instance_type        = var.instance_type
  aws-subnet-id        = "subnet-024c26c397520c8f2"
  key_name             = "DDVE6-key-pair-js"
  iam_instance_profile = module.iam_creation.instance_profile
  security_group_id    = module.ddve_firewall.security_group_id
}

#create the required volumes for the ec2 instance
module "ebs_volume" {
  source = "git::https://github.com/juergenschubert/DELLEMC-terraform-DPS-modules//modules/aws/ddve/ver6/ebs_volume?ref=main"
  region                     = var.aws_region
  amount_of_metadisk         = var.amount_of_metadisk
  ebs_volume_metadisk_sizeGB = var.ebs_volume_size 
  ec2_instance_id            = module.aws_instance.ec2_id
}

output "bucket_name" {
  value       = module.s3_bucket.ddve_bucket_name
  description = "The value you do need for DDVE configuration on the bucket name!"
}
output "Instance_id" {
  value       = module.aws_instance.ec2_id
  description = "AWS instance ID for default sysadmin password"
}
output "DDVE_public_IP" {
  value       = module.aws_instance.public_v4_ip
  description = "Public IP of your DDVE"
}
output "DDVE_EIO" {
  value       = aws_eip.lb.public_ip
  description = "Public EIP ID"
}
output "DDVE_DNS" {
  value = module.aws_instance.public_dns_name
  description = "public DNS name"
}