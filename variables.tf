# ***** Network state *****
variable "net_remote_state_region" {
  description = "Region for network remote state"
  type        = string
  nullable    = false
}

variable "net_backet_remote_state" {
  description = "Bucket name for network remote state"
  type        = string
  nullable    = false
}

variable "net_key_remote_state" {
  description = "Key name for network remote state"
  type        = string
  nullable    = false
}

# ***** EC2 *****
variable "env" {
  description = "Specify environment"
  type        = string
  nullable    = false
}

variable "lt_ami_id" {
  description = "Specify AWS AMI id for the instnces"
  type        = string
  nullable    = false
  default     = ""
}


variable "lt_instance_type" {
  description = "AWS instance type"
  type        = string
  nullable    = false
}

variable "lt_default_ami" {
  description = "Default ami for EC2 instance"
  type        = string
  nullable    = false
}

variable "lt_launch_template_name" {
  description = "Instance hostname"
  type        = string
  nullable    = false
}

variable "lt_key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  nullable    = false
  default     = ""
}

variable "lt_vpc_security_groups" {
  description = "List of security group names to associate with"
  type        = list(string)
  nullable    = false
}

variable "lt_user_data_yes" {
  description = "User data exists (YES/NO)"
  type        = bool
  nullable    = false
  default     = true
}

variable "lt_shutdown_behavior" {
  description = "Shutdown behavior for the instance"
  type        = string
  nullable    = false
  default     = "terminate"
}

variable "lt_update_default_version" {
  description = "Whether to update Default Version each update"
  type        = bool
  nullable    = false
  default     = true
}

variable "lt_cloudinit_content" {
  description = "Cloudinit body content"
  type = string
  default = ""
}

variable "lt_cloudinit_gzip" {
  description = "Specify whether or not to gzip the rendered output (defaults to true). Switch default to false"
  type = bool
  default = false
}

variable "lt_cloudinit_base64_encode" {
  description = "Specify whether or not to gzip the rendered output (defaults to true). Switch default to false"
  type = bool
  default = true
}
