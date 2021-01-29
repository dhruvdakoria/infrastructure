resource "aws_ecs_service" "api" {
  name            = "${var.name}-api"
  task_definition = aws_ecs_task_definition.api.id
  cluster         = var.aws_ecs_cluster_main_arn

  load_balancer {
    target_group_arn = var.aws_lb_target_group_api_arn
    container_name   = "${var.name}-api"
    container_port   = var.container_api_port
  }

  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = "ECS"
  }
}
