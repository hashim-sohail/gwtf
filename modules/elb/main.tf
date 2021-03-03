# Create a new load balancer
resource "aws_elb" "icap_elb_iz" {
  name               = "icap-elb-iz"
  subnets            = [var.subnets[0].id]
  security_groups    =  [var.security_group_for_nodes_id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [var.ec_instances[0].id, var.ec_instances[1].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = merge(
    var.common_tags,
    {
      Name = "icap_elb_iz"
    },
  )
}