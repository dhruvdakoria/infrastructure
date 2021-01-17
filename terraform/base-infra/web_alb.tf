resource "aws_lb" "web_alb" {
  name               = "${var.name}-service-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.alb.id}"]
  subnets            = aws_subnet.public.*.id

  tags = {
    Name = "${var.name}-service-web-alb"
  }
}

resource "aws_lb_target_group" "web" {
  name  = "${var.name}-web-tg"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "web_alb" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

