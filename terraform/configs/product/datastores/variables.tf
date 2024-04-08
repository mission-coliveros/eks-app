# ----------------------------------------------------------------------------------------------------------------------
# Core
# ----------------------------------------------------------------------------------------------------------------------

variable "org_name" {
  description = "Organization name, used in resource prefixes"
  type        = string
  default     = "cmoliveros"
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
  type    = number
  default = null
}

# ----------------------------------------------------------------------------------------------------------------------
# OpenZFS
# ----------------------------------------------------------------------------------------------------------------------

variable "fsx_storage_capacity" {
  description = "Storage capacity of the main FSx for OpenZFS filesystem"
  type        = number
  default     = 100
}

variable "zfs_volume_overrides" {
  description = "Can be used to override filesystem deployments on a per-environment basis"
  type        = any
  default     = {}
}
