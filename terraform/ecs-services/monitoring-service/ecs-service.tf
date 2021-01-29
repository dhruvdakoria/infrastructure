resource "aws_ecs_service" "monitoring" {
  name            = "${var.name}-monitoring"
  task_definition = aws_ecs_task_definition.monitoring.id
  cluster         = var.aws_ecs_cluster_main_arn

  load_balancer {
    target_group_arn = var.aws_lb_target_group_monitoring_arn
    container_name   = "${var.name}-monitoring"
    container_port   = var.container_monitoring_port
  }

  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = "ECS"
  }
}
