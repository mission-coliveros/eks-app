# ----------------------------------------------------------------------------------------------------------------------
# Operations
# ----------------------------------------------------------------------------------------------------------------------

variable "org_name" {
  default = "cmoliveros"
}

variable "stack_name" {
  description = "Name of the stack being deployed"
  type        = string
  default     = "shared"
}

variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-2"
}

variable "aws_backup_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-2" # Other regions are disabled for this account
}

variable "aws_account_id" {
  description = "AWS account to deploy to"
  type        = string
}
