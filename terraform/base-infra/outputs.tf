output "aws_ecs_cluster_main_arn" {
  value = aws_ecs_cluster.main.arn
}

output "aws_ecs_cluster_monitoring_arn" {
  value = aws_ecs_cluster.monitoring.arn
}

output "aws_lb_target_group_web_arn" {
  value = aws_lb_target_group.web.arn
}

output "aws_lb_target_group_api_arn" {
  value = aws_lb_target_group.api.arn
}

output "aws_lb_target_group_monitoring_arn" {
  value = aws_lb_target_group.monitoring.arn
}

output "aws_iam_role_execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}

output "aws_iam_role_task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "aws_lb_api_dns_name" {
  value = aws_lb.api_alb.dns_name
}

output "aws_lb_web_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "aws_lb_monitoring_dns_name" {
  value = aws_lb.monitoring_alb.dns_name
}

output "aws_vpc_main_id" {
  value       = aws_vpc.main.id
}

output "aws_subnet_public_id" {
  value       = aws_subnet.public.0.id
}

output "aws_subnet_private_1_id" {
  value       = aws_subnet.private.0.id
}

output "aws_subnet_private_2_id" {
  value       = aws_subnet.private.1.id
}

output "aws_subnet_private_3_id" {
  value       = aws_subnet.private.2.id
}

output "aws_security_group_ecs_id" {
  value       = aws_security_group.ecs.id
}