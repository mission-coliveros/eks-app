# ----------------------------------------------------------------------------------------------------------------------
# Core
# ----------------------------------------------------------------------------------------------------------------------

variable "org_name" {
  type = string
  default = "cmoliveros"
}

variable "stack_name" {
  description = "Name of the stack being deployed"
  type        = string
  default     = "product"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "aws_account_id" {
  description = "AWS account to deploy to"
  type        = string
}

variable "availability_zones" {
  description = "AWS availability zones to deploy to"
  type        = list(string)
  default     = []
}

variable "active_availability_zones" {
  type = number
  default = null
}

variable "default_ec2_instance_type" {
  description = "Default instance types to deploy EC2 instances as"
  type        = string
  default     = "m7i.large"
}

variable "cluster_deployed" {
  default = true
}

variable "eks_cluster_version" {
  description = ""
  type        = string
  default     = "1.29"
}

variable "eks_cluster_name_override" {
  description = ""
  type        = string
  default     = null
}
