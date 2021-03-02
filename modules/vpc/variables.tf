# Input variable definitions

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "vpc_icap_ew1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_region" {
  description = "default region of vpc"
  type        = string
  default     = "us-east-1"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "vpc_private_subnets_cidr" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets_cidr" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Tags to apply to all resources created"
  type        = map(string)
  default = {
    Terraform   = "true"
  }
}
