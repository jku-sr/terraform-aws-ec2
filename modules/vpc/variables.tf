variable "region" {
  description = "Default instance for the VPC"
  type        = string
  default     = ""
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

variable "cidr_block" {
  description = "Default CIDR Block"
  type        = string
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "availability_zones" {
  description = "AZs for Subnets"
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Set this to true to enable a public IP when a resource is added to this Subnet"
  type        = bool
  default     = true
}

variable "default_tags" {
  description = ""
  type        = map(any)
  default = {
    Environment = ""
    "Is Production" : null
  }
}
