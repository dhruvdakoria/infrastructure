resource "aws_ecs_task_definition" "api" {
  family                   = "${var.name}-api"
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
          "containerPort": ${var.container_api_port}
        }
      ],
      "environment": [
        {
          "name": "PORT",
          "value": "${var.container_api_port}"
        },
        {
          "name": "DB",
          "value": "${var.database_name}"
        },
        {
          "name": "DBUSER",
          "value": "${var.database_username}"
        },
        {
          "name": "DBPASS",
          "value": "${var.database_password}"
        },
        {
          "name": "DBHOST",
          "value": "${var.database_url}"
        },
        {
          "name": "DBPORT",
          "value": "5432"
        }
      ],
      "memoryReservation" : ${var.memory_reserv},
      "image": "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.name}-api:latest",
      "name": "${var.name}-api",
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${var.name}-api",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
]
DEFINITION
}
