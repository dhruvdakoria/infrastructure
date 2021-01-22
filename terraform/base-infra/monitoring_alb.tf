data "aws_iam_policy_document" "monitoring-logs" {
  statement {
    actions = [
      "s3:PutObject",
    ]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    resources = [
      "arn:aws:s3:::${var.name}-elb-logs-monitoring/*",
    ]
  }
}

resource "aws_s3_bucket" "monitoring-logs" {
  bucket        = "${var.name}-elb-logs-monitoring"
  acl           = "private"
  policy        = data.aws_iam_policy_document.monitoring-logs.json
  force_destroy = true
}

resource "aws_lb" "monitoring_alb" {
  name               = "${var.name}-monitoring-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id
  access_logs {
    bucket   = aws_s3_bucket.monitoring-logs.id
    enabled = true
  }
  tags = {
    Name = "${var.name}-monitoring-alb"
  }
}

resource "aws_lb_target_group" "monitoring" {
  name  = "${var.name}-monitoring-tg"

  port        = 1337
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "monitoring_alb" {
  load_balancer_arn = aws_lb.monitoring_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.monitoring.arn
  }
}

