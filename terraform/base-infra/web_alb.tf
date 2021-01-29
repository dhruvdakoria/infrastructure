data "aws_iam_policy_document" "web-logs" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    resources = [
      "arn:aws:s3:::${var.name}-elb-logs-web/*",
    ]
  }
}

resource "aws_s3_bucket" "web-logs" {
  bucket        = "${var.name}-elb-logs-web"
  acl           = "private"
  policy        = data.aws_iam_policy_document.web-logs.json
  force_destroy = true
}

resource "aws_lb" "web_alb" {
  name               = "${var.name}-service-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id
  access_logs {
    bucket   = aws_s3_bucket.web-logs.id
    enabled = true
  }
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
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "web_alb_443" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}