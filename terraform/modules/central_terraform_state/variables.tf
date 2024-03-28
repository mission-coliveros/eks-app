variable "spoke_accounts" {
  description = "List of spoke accounts and their IDs to grant path-based permissions to"
  type        = any
}

variable "bucket_name" {
  description = "Name of Terraform state bucket"
  type        = string
}

variable "environment_name" {
  description = "Name of logical environment"
  type        = string
}

variable "aws_backup_region" {
  description = "AWS region to deploy backup TF state bucket to"
  type        = string
  default     = "us-east-2"
}

variable "resource_prefix" {
  description = "Prefix to assign to all created resources"
  type        = string
}
