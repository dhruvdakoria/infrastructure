
data "aws_ami" "latest-ecs" {
  most_recent = true
  owners      = ["591542846629"] # Amazon

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "main" {
  name                 = "ECS-Instance-${var.name}"
  image_id             = data.aws_ami.latest-ecs.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.ecs.id]
  associate_public_ip_address = "true"
  key_name                    = var.ecs_key_pair_name
  user_data                   = file("${path.module}/user_data.sh")
}

resource "aws_launch_configuration" "monitoring" {
  name                 = "Monitoring-${var.name}"
  image_id             = data.aws_ami.latest-ecs.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.ecs.id]
  associate_public_ip_address = "true"
  key_name                    = var.ecs_key_pair_name
  user_data                   = file("${path.module}/user_data_monitoring.sh")
}

resource "aws_autoscaling_group" "main" {
  name = "${var.name}-ecs-autoscaling-group"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  vpc_zone_identifier = aws_subnet.private.*.id
  launch_configuration = aws_launch_configuration.main.name
  health_check_type = "ELB"

    tag {
    key                 = "Name"
    value               = "ECS-Instance-${var.name}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "monitoring" {
  name = "${var.name}-ecs-autoscaling-group-monitoring"
  max_size = 2
  min_size = 1
  desired_capacity = 1
  vpc_zone_identifier = aws_subnet.private.*.id
  launch_configuration = aws_launch_configuration.monitoring.name
  health_check_type = "ELB"

    tag {
    key                 = "Name"
    value               = "Monitoring-${var.name}"
    propagate_at_launch = true
  }
}

resource "aws_iam_role" "ecs-instance-role" {
  name = "${var.name}-ecs-instance-role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "${var.name}-ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.id
}