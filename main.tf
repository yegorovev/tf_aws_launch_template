data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.net_backet_remote_state
    key    = var.net_key_remote_state
    region = var.net_remote_state_region
  }
}

data "aws_key_pair" "kp" {
  filter {
    name   = "tag:ec2"
    values = [var.ec2_hostname]
  }
  filter {
    name   = "tag:ENV"
    values = [var.env]
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ec2_default_ami]
  }
}

locals {
  ec2_vpc_security_group_ids = matchkeys(data.terraform_remote_state.network.outputs.sg[*].sg.id,
    data.terraform_remote_state.network.outputs.sg[*].sg.name,
  var.ec2_vpc_security_groups)
}

resource "aws_launch_template" "launch_template" {
  name                   = var.ec2_launch_template_name
  image_id               = var.ec2_ami_id != "" ? var.ec2_ami_id : data.aws_ami.ami.id
  instance_type          = var.ec2_instance_type
  key_name               = var.ec2_key_name != "" ? var.ec2_key_name : data.aws_key_pair.kp.key_name
  vpc_security_group_ids = local.ec2_vpc_security_group_ids
}
