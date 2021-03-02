# Output variable definitions

output "icap_elb_ew1b" {
  description = "ELB of Icap"
  value       = module.elb.icap_elb_ew1b
}