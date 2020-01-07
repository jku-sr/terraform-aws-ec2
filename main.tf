provider "aws" {
  version = "~> 2.40"
  region  = var.region
}

terraform {
  required_version = ">= 0.12"
}

module "vpc" {
  source               = "./modules/vpc"
  cidr_block           = var.cidr_block
  availability_zones   = var.availability_zones
  has_multiple_subnets = var.has_multiple_subnets
  private_subnet_count = var.private_subnet_count
  public_subnet_count  = var.public_subnet_count
  enable_dns_hostnames = var.enable_dns_hostnames
  default_tags         = var.default_tags
}

resource "aws_instance" "web" {
  count = var.web_count

  ami               = lookup(var.amis, var.region)
  instance_type     = var.instance_type
  availability_zone = element(var.availability_zones, count.index)
  subnet_id         = module.vpc.public_subnet_ids[count.index]
  key_name          = var.ssh_key_name

  tags = merge(map(
    "Name", format("${var.ec2_name}-%s-${count.index}", var.default_tags["Environment"]),
    "Auto-shutdown", "True"
    ),
  var.default_tags)

  security_groups = [aws_security_group.this.id]

  depends_on = [aws_security_group.this]
}

resource "aws_volume_attachment" "this" {
  count = var.ebs_count

  device_name = "/dev/sdh"
  instance_id = aws_instance.web.*.id[count.index]
  volume_id   = aws_ebs_volume.this.*.id[count.index]
}

resource "aws_ebs_volume" "this" {
  count = var.ebs_count

  availability_zone = aws_instance.web.*.availability_zone[count.index]
  size              = 20
}
resource "aws_security_group" "this" {
  name        = format("${var.ec2_name}-%s-sg", var.default_tags["Environment"])
  description = "Inbound Security Group for SSH"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.sg_ingress_cidr_blocks
    }
  }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}