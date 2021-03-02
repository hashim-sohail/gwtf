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

variable "network_interface_id_1" {
  description = "network interface id"
  type        = string
  default     = "nwid1"
}

variable "subnet_prv_id" {
  description = "private subnet id"
  type        = string
  default     = "subprvid"
}

variable "subnet_prv2_id" {
  description = "private subnet2 id"
  type        = string
  default     = "subprvisd"
}

variable "subnets" {
  description = "all subnets"
  type        = list
  default     = ["subprvisd"]
}

variable "security_group_for_nodes_id" {
  description = "security_group_nodes"
  type        = string
  default     = ""
}

# variable "pem_key_name" {
#   description = "pem key name"
#   type        = string
#   default     = "furqan-gw-ew1"
# }

variable "pem_key_name" {
  description = "pem key name"
  type        = string
  default     = "icap-bastion-key"
}