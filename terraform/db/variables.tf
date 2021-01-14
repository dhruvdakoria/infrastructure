variable "name" { }

variable "vpc_id" {}

variable "allocated_storage" {
  default = "32"
}

variable "engine_version" {
  default = "9.6"
}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "storage_type" {
  default = "gp2"
}

variable "database_identifier" {}

variable "snapshot_identifier" {
  default = ""
}

variable "database_name" {}

variable "database_password" {}

variable "database_username" {}

variable "database_port" {
  default = "5432"
}

variable "backup_retention_period" {
  default = "30"
}

variable "backup_window" {
  # 12:00AM-12:30AM ET
  default = "04:00-04:30"
}

variable "maintenance_window" {
  # SUN 12:30AM-01:30AM ET
  default = "sun:04:30-sun:05:30"
}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "skip_final_snapshot" {
  default = true
}

variable "copy_tags_to_snapshot" {
  default = false
}

variable "multi_availability_zone" {
  default = false
}

variable "storage_encrypted" {
  default = false
}

variable "aws_subnet_private_1_id" {
  description = "Subnet private ID"
}

variable "aws_subnet_private_2_id" {
  description = "Subnet private ID"
}

variable "aws_subnet_private_3_id" {
  description = "Subnet private ID"
}