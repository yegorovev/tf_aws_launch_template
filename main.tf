data "terraform_remote_state" "network" {
  count = var.lt_vpc_security_groups != [] ? 1 : 0

  backend = "s3"

  config = {
    bucket = var.net_backet_remote_state
    key    = var.net_key_remote_state
    region = var.net_remote_state_region
  }
}

locals {
  count = var.lt_vpc_security_groups != [] ? 1 : 0

  lt_vpc_security_group_ids = matchkeys(data.terraform_remote_state.network[0].outputs.security_groups[*].sg.id,
    data.terraform_remote_state.network[0].outputs.security_groups[*].sg.name,
  var.lt_vpc_security_groups)
}

data "aws_key_pair" "kp" {
  filter {
    name   = "tag:ec2"
    values = [var.lt_launch_template_name]
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
    values = [var.lt_default_ami]
  }
}

data "cloudinit_config" "server_config" {
  count = var.lt_user_data_yes ? 1 : 0

  gzip          = var.lt_cloudinit_gzip
  base64_encode = var.lt_cloudinit_base64_encode
  part {
    content_type = "text/cloud-config"
    content      = var.lt_cloudinit_content
  }
}

resource "aws_launch_template" "launch_template" {
  name                                 = var.lt_launch_template_name
  image_id                             = var.lt_ami_id != "" ? var.lt_ami_id : data.aws_ami.ami.id
  instance_type                        = var.lt_instance_type
  key_name                             = var.lt_key_name != "" ? var.lt_key_name : data.aws_key_pair.kp.key_name
  vpc_security_group_ids               = var.lt_vpc_security_groups != [] ? local.lt_vpc_security_group_ids : []
  user_data                            = var.lt_user_data_yes ? data.cloudinit_config.server_config[0].rendered : null
  instance_initiated_shutdown_behavior = var.lt_shutdown_behavior
  update_default_version               = var.lt_update_default_version
}
