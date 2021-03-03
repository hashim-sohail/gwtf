output "icap_ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.icap_ec2_bastion.public_ip
}

# output "icap_eip_bastion" {
#   description = "Elastic IP address of the EC2 instance"
#   value       = aws_eip.icap_eip_bastion.public_ip
# }