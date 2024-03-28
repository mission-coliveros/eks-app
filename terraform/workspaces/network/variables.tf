# ----------------------------------------------------------------------------------------------------------------------
# Core
# ----------------------------------------------------------------------------------------------------------------------

variable "org_name" {
  type    = string
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

# ----------------------------------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------------------------------

variable "availability_zones" {
  description = "AWS availability zones to deploy to"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "security_group_overrides" {
  description = "Used to override values in local.security_groups"
  type        = any
  default     = {}
}

variable "single_nat_gateway" {
  description = ""
  type        = bool
  default     = false
}

variable "enable_flow_log" {
  description = ""
  type        = bool
  default     = true
}

variable "security_group_rule_overrides" {
  description = "Used to override values in local.security_group_rules"
  type        = any
  default     = {}
}
