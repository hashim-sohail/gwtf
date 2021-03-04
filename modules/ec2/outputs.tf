# Output variable definitions
output "ec_instances" {
  value = aws_instance.rke-node
}

output "addresses" {
  value = aws_instance.rke-node[*].public_ip
}

output "internal_ips" {
  value = aws_instance.rke-node[*].private_ip
}

output "ssh_username" {
  value = "ubuntu"
}

output "private_key" {
  value = tls_private_key.node-key.private_key_pem
}