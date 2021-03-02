resource "aws_lb" "icap_alb_ew1b" {
  name               = "icap-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_for_nodes_id]

  subnet_mapping {
    subnet_id            = var.subnet_prv_id
    private_ipv4_address = "10.0.1.50"
  }

  subnet_mapping {
    subnet_id            = var.subnet_prv_id
    private_ipv4_address = "10.0.2.60"
  }
  depends_on = [var.ec_instances]

}
