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


variable "subnets" {
  description = "list of subnets"
  type        = list
  default     = ["sub1", "sub2"]
}

variable "security_group_for_nodes_id" {
  description = "security_group_nodes"
  type        = string
}

variable "ec_instances" {
  description = "ec_instances"
  type        = list
  default     = ["ec_instances", "instance2"]
}