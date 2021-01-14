resource "aws_ecs_service" "web" {
  name            = "${var.name}-web"
  task_definition = aws_ecs_task_definition.web.id
  cluster         = var.aws_ecs_cluster_main_arn

  load_balancer {
    target_group_arn = var.aws_lb_target_group_web_arn
    container_name   = "${var.name}-web"
    container_port   = var.container_web_port
  }

  launch_type                        = "EC2"
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = "ECS"
  }
}
