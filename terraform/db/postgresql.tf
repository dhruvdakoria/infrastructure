#data "aws_subnet_ids" "private" {
#  vpc_id = var.vpc_id
#    filter {
#      name = "tag:Name"
#      values = ["${var.name}-private"]
#    }
#}
#
#data "aws_subnet" "private" {
#  count = length(data.aws_subnet_ids.private.ids)
#  id    = tolist(data.aws_subnet_ids.private.ids)[count.index]
#}
#
########################
## DB Instance
########################
resource "aws_db_instance" "postgresql" {
  allocated_storage          = var.allocated_storage
  engine                     = "postgres"
  engine_version             = var.engine_version
  identifier                 = var.database_identifier
  instance_class             = var.instance_type
  storage_type               = var.storage_type
  name                       = var.database_name
  password                   = var.database_password
  username                   = var.database_username
  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  final_snapshot_identifier  = "${var.database_identifier}-snapshot-${md5(timestamp())}"
  skip_final_snapshot        = var.skip_final_snapshot
  copy_tags_to_snapshot      = var.copy_tags_to_snapshot
  multi_az                   = var.multi_availability_zone
  port                       = var.database_port
  vpc_security_group_ids     = [aws_security_group.rds.id]
  db_subnet_group_name       =  aws_db_subnet_group.rds_subnetgroup.name
  parameter_group_name       =  aws_db_parameter_group.default.name
  storage_encrypted          =  var.storage_encrypted

}

resource "aws_db_subnet_group" "rds_subnetgroup" {
  name   = "${var.name}-subnet-group"
  subnet_ids  = [var.aws_subnet_private_1_id, var.aws_subnet_private_2_id, var.aws_subnet_private_3_id]
}

resource "aws_db_parameter_group" "default" {
  name   = "${var.name}-parameter-group"
  family = "postgres9.6"
}

########################
## Security group resources
########################
resource "aws_security_group" "rds" {
  name   = "${var.name}-allow-rds"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-allow-rds"
  }
}