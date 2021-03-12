# Input variable definitions
variable "common_tags" {
  description = "General Tags to apply to resources created"
  type        = map(string)
  default = {
    Service = "ICAP Cluster"
    Owner   = "Furqan Aziz"
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

variable "network_interface_id_1" {
  description = "network interface id"
  type        = string
  default     = "nwid1"
}

variable "subnets" {
  description = "all subnets"
  type        = list
  default     = ["subprvisd"]
}

variable "security_group_for_nodes_id" {
  description = "security_group_nodes"
  type        = string
}

variable "pem_key_name" {
  description = "pem key name"
  type        = string
  default     = "icap-bastion-key"
}