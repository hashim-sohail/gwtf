# Output variable definitions

# output "ec2_instance_public_ips" {
#   description = "Public IP addresses of EC2 instances"
#   value       = module.ec2_instances.public_ip
# }

output "ec_instances" {
  value = [aws_instance.icap_ec2_node40_ew1a,aws_instance.icap_ec2_node50_ew1a] 
}
