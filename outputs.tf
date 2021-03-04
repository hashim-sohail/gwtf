# Output variable definitions

output "icap_node1" {
  description = "Icap ec2 node 1"
  value       = module.nodes.ec_instances[0].public_ip
}

output "icap_node2" {
  description = "Icap ec2 node 2"
  value       = module.nodes.ec_instances[1].public_ip
}

output "icap_node3" {
  description = "Icap ec2 node 2"
  value       = module.nodes.ec_instances[2].public_ip
}

output "icap_node4" {
  description = "Icap ec2 node 2"
  value       = module.nodes.ec_instances[3].public_ip
}

output "icap_elb_iz" {
  description = "ELB of Icap"
  value       = module.elb.icap_elb_iz.dns_name
}