# Output variable definitions

# output "ec2_instance_public_ips" {
#   description = "Public IP addresses of EC2 instances"
#   value       = module.ec2_instances.public_ip
# }

output "ec_instances" {
  value = [aws_instance.icap_ec2_node1_ew1b,aws_instance.icap_ec2_node2_ew1b] 
}
