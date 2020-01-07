variable "region" {
  type        = string
  description = "Default instance for the VPC"
  default     = ""
}

variable "amis" {
  type = map(string)

  default = {
    us-east-1 = ""
    us-east-2 = ""
  }
}

variable "web_count" {
  description = "Amount of EC2 web isntances to deploy"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance size, default is t2.micro (free tier)"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "SSH Key Name in AWS that will be used to access the EC2 Instance"
  type        = string
  default     = ""
}

variable "ec2_name" {
  description = "Name for EC2 Instance. This will be formatted to append different values as well such as Environment; e.g. web-dev-1"
  type        = string
  default     = ""
}

variable "default_tags" {
  description = "Default tags used for all resources. This is to better consolidate billing"
  type        = map(string)

  default = {
    "Business Unit" = ""
  }
}

variable "cidr_block" {
  description = "VPC CIDR Block used to carve up subnets"
  type        = string
  default     = ""
}

variable "availability_zones" {
  description = "Availbility Zones to deploy subnets into"
  default     = []
}
variable "has_multiple_subnets" {
  description = "Determines whether the VPC has multiple subnets"
  type        = bool
  default     = false
}

variable "private_subnet_count" {
  description = "Number of private subnet to launch inside VPC"
  type        = number
  default     = 1
}

variable "public_subnet_count" {
  description = "Number of public subnet to launch inside VPC"
  type        = number
  default     = 2
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "ebs_count" {
  description = "Number of EBS Volumes to deploy and attach onto the EC2 Instance"
  type        = number
  default     = 0
}

variable "sg_ingress_ports" {
  description = "List of ingress ports to be allowed"
  default     = []
}

variable "sg_ingress_cidr_blocks" {
  description = "Inbound CIDR Blocks"
  default     = []
}