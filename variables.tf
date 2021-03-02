# Input variable definitions
variable "common_tags" {
  description = "General Tags to apply to resources created"
  type        = map(string)
  default = {
    Service = "ICAP Cluster"
    Owner   = "Khawar"
    Delete  = "Yes"
    Team    = "DevOps"
    Scope   = "Created for demo"
  }
}

variable "region" {
  description = "Region"
  type        = string
  default     = "eu-west-1"
}