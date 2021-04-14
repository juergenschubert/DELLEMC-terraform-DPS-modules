
data "aws_ami" "ddve6" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = [var.ami_filtername]
  }
}

resource "aws_instance" "terraform_ddve" {
  ami = data.aws_ami.ddve6.id
  instance_type = var.instance_type
  # subnet the instance runs into
  subnet_id = var.aws-subnet-id
  # key name
  key_name = var.keypair_name
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
output "public_dns_name" {
  value = aws_instance.terraform_ddve.public_dns
}