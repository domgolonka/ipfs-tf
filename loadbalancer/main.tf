resource "aws_lb" "blockparty" {
  name                             = "${var.project}-${var.env}-${var.name}"
  load_balancer_type               = "network"
  internal                         = var.is_internal
  subnets                          = var.subnets_ids
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "blockparty" {
  for_each               = var.ecs_services
  name                   = "${var.project}-${each.key}-tg"
  target_type            = "ip"
  port                   = each.value.lb_port
  protocol               = each.value.protocol
  vpc_id                 = var.vpc_id
  deregistration_delay   = 15
  connection_termination = false

  health_check {
    protocol            = "HTTP"
    port                = each.value.container_port
    path                = each.value.health_check_path
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = var.hc_interval
    timeout             = var.hc_timeout
  }
  depends_on = [aws_lb.blockparty]
}

# Listener (redirects traffic from the load balancer to the target group)
resource "aws_lb_listener" "blockparty" {
  for_each          = aws_lb_target_group.blockparty
  load_balancer_arn = aws_lb.blockparty.id
  port              = each.value.port
#  protocol          = "TLS"
  protocol          = "TCP"
#  certificate_arn   = var.listener_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blockparty[each.key].arn
  }
}