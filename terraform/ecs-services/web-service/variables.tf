variable "name" {
  description = "Name of the cluster"
}

variable "region" {
  description = "Region of cluster"
}

variable "aws_ecs_cluster_main_arn" {
  default = ""
}

variable "aws_lb_target_group_web_arn" {
  default = ""
}

variable "aws_iam_role_execution_role_arn" {
  default = ""
}

variable "aws_iam_role_task_role_arn" {
  default = ""
}

variable "container_web_port" {
  default = "80"
}

variable "memory_reserv" {
  default = "100"
}

variable "aws_account_id" {
  default = ""
}

variable "aws_lb_api_dns_name" {
  default = ""
}