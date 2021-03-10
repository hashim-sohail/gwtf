variable "region" {
  default =  "eu-west-2"
}

variable "instance_type" {
  default = "t2.large"
}

variable "cluster_id" {
  default = "rke"
}

variable "docker_install_url" {
  default = "https://releases.rancher.com/install-docker/19.03.sh"
}

variable "security_group_for_nodes_id" {
  description = "security_group_nodes"
  type        = string
}

variable "subnets" {
  description = "all subnets"
  type        = list
  default     = ["subprvisd"]
}