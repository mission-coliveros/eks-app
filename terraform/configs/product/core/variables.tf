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
