resource "aws_security_group" "alb" {
  name   = "${var.name}-allow-http-alb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-allow-http-alb"
  }
}