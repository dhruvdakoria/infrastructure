resource "aws_ecs_task_definition" "web" {
  family                   = "${var.name}-web"
  execution_role_arn       = var.aws_iam_role_execution_role_arn
  task_role_arn            = var.aws_iam_role_task_role_arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
    {
      "memoryReservation" : 50,
      "image": "grafana/fluent-bit-plugin-loki:1.6.0-amd64",
      "name": "log_router",
      "firelensConfiguration": {
          "type": "fluentbit",
          "options": {
              "enable-ecs-log-metadata": "true"
          }
      }
    },
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
          "logDriver": "awsfirelens",
          "options": {
              "Name": "loki",
              "Url": "http://${var.loki_ip}:3100/loki/api/v1/push",
              "Labels": "{job=\"firelens\"}",
              "RemoveKeys": "container_id,ecs_task_arn",
              "LabelKeys": "container_name,ecs_task_definition,source,ecs_cluster",
              "LineFormat": "key_value"
          }
      }
    }
]
DEFINITION
}
