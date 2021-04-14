variable "security_group_name" {
  default = "ddve6_sg_terraform"
}
# define the Ports and the description for ingress rules
locals {
  ingress_rules = [{
    port        = 443
    description = "Port for https"
    },
    {
      port        = 3009
      description = "Port for RestAPIs"
    },
    {
      port        = 80
      description = "Port for http"
    },
    {
      port        = 22
      description = "Port for ssh"
    },
    {
      port        = 2049
      description = "Port for DD Boost and replication"
    },
    {
      port        = 2052
      description = "Port for CSM"
    },
    {
      port        = 111
      description = "Port for CSM"
    },
    {
      port        = 2051
      description = "Port for DD Boost and replication"
    }
  ]
}

resource "aws_security_group" "ddvesg" {
  name        = var.security_group_name
  description = "Allow TLS traffic for ddve"
  tags = {
    Name = var.security_group_name
  }
  egress {
    description = "Scheunentor ipv4"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description      = "Scheunentor ipv6"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      description = ingress.value.description
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      description      = ingress.value.description
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

output "security_group_id" {
    value = aws_security_group.ddvesg.id
}
