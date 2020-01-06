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

variable "instance_type" {
  type        = string
  description = "Instance size, default is t2.micro (free tier)"
  default     = "t3.micro"
}

variable "web_count" {
  type        = number
  description = "Amount of EC2 web isntances to deploy"
  default     = 1
}

variable "ec2_name" {
  type    = string
  default = ""
}

variable "ec2_environment" {
  type    = string
  default = "dev"
}

variable "default_tags" {
  type = map(string)

  default = {
    "Business Unit" = ""
  }
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR Block used to carve up subnets"
  default     = ""
}

variable "availability_zones" {
  description = ""
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

variable "sg_name" {
  description = "default name for AWS Security Group"
  type        = string
  default     = ""
}
variable "sg_description" {
  description = "description for usage of Security Group"
  type        = string
  default     = ""
}
