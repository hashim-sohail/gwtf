# Input variable definitions
variable "common_tags" {
  description = "General Tags to apply to resources created"
  type        = map(string)
  default = {
    Service = "ICAP Cluster"
    Owner   = "Furqan"
    Delete  = "Yes"
    Team    = "DevOps"
    Scope   = "Created for icap demo"
  }
}

variable "region" {
  description = "Region"
  type        = string
  default     = "eu-west-1"
}

variable "pem_key_name" {
  description = "pem key name"
  type        = string
  default     = "icap-bastion-key"
}

# variable "pem_key_name" {
#   description = "pem key name"
#   type        = string
#   default     = "furqan-gw-ew1"
# }