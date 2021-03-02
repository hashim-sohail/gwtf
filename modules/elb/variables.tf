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


variable "subnet_prv_id" {
  description = "private subnet id"
  type        = string
  default     = "subprvid"
}

variable "security_group_for_nodes_id" {
  description = "security_group_nodes"
  type        = string
  default     = "sg_nodes"
}

variable "ec_instances" {
  description = "ec_instances"
  type        = list
  default     = ["ec_instances", "instance2"]
}