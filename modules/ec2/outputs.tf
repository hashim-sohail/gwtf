# Output variable definitions
output "ec_instances" {
  value = [aws_instance.icap_ec2_node_01_iz,aws_instance.icap_ec2_node_02_iz] 
}
