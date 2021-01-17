variable "name" {
  description = "Name of the cluster"
}

variable "region" {
  description = "Region of cluster"
}

variable "aws_ecs_cluster_main_arn" {
  default = ""
}

variable "aws_lb_target_group_api_arn" {
  default = ""
}

variable "aws_iam_role_execution_role_arn" {
  default = ""
}

variable "aws_iam_role_task_role_arn" {
  default = ""
}

variable "container_api_port" {
  default = "8000"
}

variable "memory_reserv" {
  default = "100"
}

variable "aws_account_id" {
  default = ""
}

variable "database_url" {
  default = ""
}

variable "database_name" {}

variable "database_password" {}

variable "database_username" {}

variable "database_port" {
  default = "5432"
}

variable "loki_ip" {
  default = ""
}