resource "aws_ecs_task_definition" "web" {
  family                   = "${var.name}-web"
  execution_role_arn       = var.aws_iam_role_execution_role_arn
  task_role_arn            = var.aws_iam_role_task_role_arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
   {
      "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": ${var.container_web_port}
        }
      ],
      "environment": [
        {
          "name": "PORT",
          "value": "${var.container_web_port}"
        },
        {
          "name" : "API_HOST",
          "value": "http://${var.aws_lb_api_dns_name}"
        }
      ],
      "memoryReservation" : ${var.memory_reserv},
      "image": "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.name}-web:latest",
      "name": "${var.name}-web",
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${var.name}-web",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
]
DEFINITION
}
