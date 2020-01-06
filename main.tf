provider "aws" {
  version = "~> 2.40"
  region  = var.region
}

terraform {
  required_version = ">= 0.12"
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = "172.24.0.0/16"
  availability_zones   = []
  has_multiple_subnets = true
  private_subnet_count = 0
  public_subnet_count  = 4
  enable_dns_hostnames = true
  default_tags = {
    Environment = ""
    "Is Production" : ""
  }
}

resource "aws_instance" "web" {
  count         = var.web_count
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnet_ids

  tags = merge(map(
    "Name", format("${var.ec2_name}-${var.ec2_environment}-%s-${count.index}", var.default_tags["Business Unit"]),
    "Auto-shutdown", "True"
    ),
  var.default_tags)

  security_groups = [aws_security_group.this.id]
}

resource "aws_security_group" "this" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = [22, 443]
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
    }
  }
}