variable "name" {
  description = "Name of the cluster"
}

variable "region" {
  description = "Region of cluster"
}

variable "ecs_key_pair_name" {
  description = "Key pair name"
}

variable "aws_security_group_monitoring_vm_id" {
  default = ""
}