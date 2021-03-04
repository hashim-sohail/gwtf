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
  default     = "eu-west-2"
}

variable "pem_key_name" {
  description = "pem key name"
  type        = string
  default     = "gw-test-key"
}