# Output variable definitions

# output "vpc_name" {
#   description = "ID of the VPC"
#   value       = module.vpc.name
# }

# output "vpc_public_subnets" {
#   description = "IDs of the VPC's public subnets"
#   value       = module.vpc.public_subnets
# }


# output "network_interface_id_1" {
#   value = aws_network_interface.icap_nic_prv_ec1.id
# }

output "subnet_pub1" {
  value = aws_subnet.icap_subnet_pub_ew1a
}


output "subnet_prv1" {
  value = aws_subnet.icap_subnet_prv_ew1b
}

output "subnet_prv2" {
  value = aws_subnet.icap_subnet_prv2_ew1b
}

output "security_group_for_nodes_id" {
  value = aws_security_group.icap_sg_nodes.id
}

# output "security_group_for_nodes" {
#   value = aws_security_group.icap_sg_nodes
# }