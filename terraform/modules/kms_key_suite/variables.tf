variable "environment_name" {
  description = "Name of environemnt to deploy to, also used for resource name prefixes"
  type        = string
}

variable "kms_key_overrides" {
  description = "Map of KMS objects, used to override default values, or add new keys"
  type        = any
  default     = {}
}

variable "default_create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}

variable "default_is_enabled" {
  description = "Specifies whether the key is enabled"
  type        = bool
  default     = true
}

variable "default_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = null
}

variable "default_enable_default_policy" {
  description = "Specifies whether to enable the default key policy. Defaults to `true`"
  type        = bool
  default     = true
}

variable "default_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = true
}

variable "default_multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (`true`) or regional (`false`) key. Defaults to `false`"
  type        = bool
  default     = false
}

variable "key_administrator_roles" {
  description = "IAM roles to grant KMS admin permissions to"
  type        = list(string)
}

variable "key_owner_roles" {
  description = "IAM roles to grant KMS owner permissions to"
  type        = list(string)
}

variable "key_symmetric_encryption_user_roles" {
  description = "IAM roles to grant KMS symmetric encryption permissions to"
  type        = list(string)
}

variable "key_administrator_groups" {
  description = "IAM user groups to grant KMS admin permissions to"
  type        = list(string)
}

variable "key_owner_groups" {
  description = "IAM user groups to grant KMS owner permissions to"
  type        = list(string)
}

variable "key_symmetric_encryption_user_groups" {
  description = "IAM user groups to grant KMS symmetric encryption permissions to"
  type        = list(string)
}

variable "set_ebs_default_encryption_key" {
  type        = bool
  description = ""
  default     = true
}

variable "autoscaling_service_role_arn" {
  description = "ARN of Autoscaling service role to attach to appropriate key/s"
  type        = string
  default     = ""
}
