resource "aws_lb" "api_alb" {
  name               = "${var.name}-service-api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = aws_subnet.public.*.id

  tags = {
    Name = "${var.name}-service-api-alb"
  }
}

resource "aws_lb_target_group" "api" {
  name  = "${var.name}-api-tg"

  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path = "/api/status"
  }
}

resource "aws_lb_listener" "api_alb" {
  load_balancer_arn = aws_lb.api_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
