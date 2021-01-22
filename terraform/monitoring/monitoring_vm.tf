data "aws_ami" "ubuntu" {
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

data "aws_iam_policy_document" "assume_by_ec2" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "ec2readyonlyaccess" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

data "aws_iam_policy" "cloudwatch_full_access" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role" "monitoring_role" {
  name               = "monitoring_ec2ReadRole"
  assume_role_policy = data.aws_iam_policy_document.assume_by_ec2.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = data.aws_iam_policy.ec2readyonlyaccess.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch-attach" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = data.aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_instance_profile" "monitoring_profile" {
  name = "monitoring_profile"
  role = aws_iam_role.monitoring_role.name
}

resource "aws_security_group" "monitoring_vm" {
  name   = "monitoring-allow-http"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monitoring-allow-http"
  }
}

resource "aws_security_group" "monitoring_vm_internal" {
  name   = "monitoring-allow-all-internal"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    security_groups = [var.aws_security_group_ecs_id]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monitoring-allow-all-internal"
  }
}

resource "aws_instance" "monitoring" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  subnet_id            = var.aws_subnet_public_id
  user_data            = file("${path.module}/user_data.sh")
  key_name             = var.ecs_key_pair_name
  vpc_security_group_ids = [aws_security_group.monitoring_vm.id, aws_security_group.monitoring_vm_internal.id]
  iam_instance_profile = aws_iam_instance_profile.monitoring_profile.name


  tags = {
    Name = "EC2-Monitoring"
  }

  volume_tags = {
    backup = "True"
  }
}


