resource "aws_ecs_task_definition" "monitoring" {
  family                   = "${var.name}-monitoring"
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
          "containerPort": ${var.container_monitoring_port}
        }
      ],
      "environment": [
        {
          "name": "PORT",
          "value": "${var.container_monitoring_port}"
        },
        {
          "name": "AWS_ACCESS_KEY_ID",
          "value": "AKIAWPCZPBGEUXH5X26J"
        },
        {
          "name": "AWS_SECRET_ACCESS_KEY",
          "value": "7YgDvTVN20ET7LcluHKnBLfiodr1WzXZHbDh5CFw"
        },
        {
          "name" : "AWS_REGION",
          "value": "${var.region}"
        }
      ],
      "memoryReservation" : ${var.memory_reserv},
      "image": "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.name}-monitoring:latest",
      "name": "${var.name}-monitoring",
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${var.name}-monitoring",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
]
DEFINITION
}
