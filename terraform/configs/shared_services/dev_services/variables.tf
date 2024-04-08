# ----------------------------------------------------------------------------------------------------------------------
# Operations
# ----------------------------------------------------------------------------------------------------------------------

variable "org_name" {
  description = "Organization name, used in resource prefixes"
  default     = "cmoliveros"
  type        = string
}

variable "stack_name" {
  description = "Name of the stack being deployed"
  type        = string
  default     = "dev-services"
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
