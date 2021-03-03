# Output variable definitions

# output "vpc_name" {
#   description = "ID of the VPC"
#   value       = module.vpc.name
# }

output "icap_elb_iz" {
  description = "ELB object"
  value       = aws_elb.icap_elb_iz
}