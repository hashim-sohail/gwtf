# Output variable definitions

output "icap_node1" {
  description = "Icap ec2 node 1"
  value       = module.ec2.ec_instances[0].public_ip
}

output "icap_node2" {
  description = "Icap ec2 node 2"
  value       = module.ec2.ec_instances[1].public_ip
}

output "icap_elb_ew1b" {
  description = "ELB of Icap"
  value       = module.elb.icap_elb_ew1b.dns_name
}