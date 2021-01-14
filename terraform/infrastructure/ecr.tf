resource "aws_ecr_repository" "web" {
  name                 = "${var.name}-web"
}

resource "aws_ecr_repository" "api" {
  name                 = "${var.name}-api"
}