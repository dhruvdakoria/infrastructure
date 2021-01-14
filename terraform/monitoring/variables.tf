variable "aws_subnet_public_id" {
  description = "Subnet public ID"
}

variable "vpc_id" {}

variable "ecs_key_pair_name" {
  description = "Key pair name"
}

variable "aws_iam_role_execution_role_arn" {
  default = ""
}

variable "aws_iam_role_task_role_arn" {
  default = ""
}

variable "aws_ecs_cluster_main_arn" {
  default = ""
}

variable "aws_security_group_ecs_id" {
  default = ""
}

