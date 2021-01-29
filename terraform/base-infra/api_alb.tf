data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "app-logs" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    resources = [
      "arn:aws:s3:::${var.name}-elb-logs-app/*",
    ]
  }
}

resource "aws_s3_bucket" "app-logs" {
  bucket        = "${var.name}-elb-logs-app"
  acl           = "private"
  policy        = data.aws_iam_policy_document.app-logs.json
  force_destroy = true
}


resource "aws_lb" "api_alb" {
  name               = "${var.name}-service-api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id
  access_logs {
    bucket   = aws_s3_bucket.app-logs.id
    enabled = true
  }
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

# resource "aws_lb_listener" "api_alb" {
#   load_balancer_arn = aws_lb.api_alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "redirect"
#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }
resource "aws_lb_listener" "api_alb" {
  load_balancer_arn = aws_lb.api_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_listener" "api_alb_443" {
  load_balancer_arn = aws_lb.api_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}