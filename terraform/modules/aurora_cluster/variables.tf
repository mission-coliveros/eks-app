# ----------------------------------------------------------------------------------------------------------------------
# Required
# ----------------------------------------------------------------------------------------------------------------------

variable "cluster_availability_zones" {
  description = "AZs to place database instances in"
  type        = list(string)
}

variable "cluster_security_group_ids" {
  description = "Security groups to assign to database instances"
  type        = list(string)
}

variable "cluster_vpc_id" {
  description = "ID of VPC to place cluster/resources in"
  type        = string
}

variable "cluster_subnets" {
  description = "Subnets to assign to cluster"
  type        = list(string)
}

# ----------------------------------------------------------------------------------------------------------------------
# Optional
# ----------------------------------------------------------------------------------------------------------------------

variable "secrets_manager_kms_key_arn" {
  description = "ARN of KMS key used to encrypt Secrets Manager secrets"
  type        = string
  default     = null
}

variable "ssm_kms_key_arn" {
  description = "ARN of KMS key used to encrypt Systems Manager parameters"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name (excluding prefix) to assign to databsae resources"
  type        = string
}

variable "cluster_engine" {
  description = "Engine type for the cluster"
  type        = string
  default     = "aurora-postgresql"
}

variable "cluster_engine_version" {
  description = "Major engine version for the cluster.  Will be used to query the latest database version if `cluster_engine_full_version` is not specified"
  type        = string
  default     = "15"
}

variable "cluster_engine_full_version" {
  description = "Full engine version for the cluster."
  type        = string
  default     = null
}

variable "cluster_storage_type" {
  description = "Storage type for the cluster"
  type        = string
  default     = "aurora-iopt1"
}

variable "cluster_parameter_group_family" {
  description = "Parameter group family for the cluster"
  type        = string
  default     = "aurora-postgresql15"
}

variable "cluster_db_parameter_group_family" {
  description = "Parameter group family for databases in the cluster"
  type        = string
  default     = "aurora-postgresql15"
}

variable "cluster_preferred_backup_window" {
  description = "Cron expression for scheduling cluster backup time windows"
  type        = string
  default     = "05:00-05:30"
}

variable "cluster_kms_key_id" {
  description = "KMS key used to encrypt the cluster"
  type        = string
  default     = null
}

variable "cluster_enabled_cloudwatch_logs_exports" {
  description = "Enabled log export types for the cluster"
  type        = list(string)
  default     = []
}

variable "cluster_instance_overrides" {
  description = "Can be used to override `local.cluster_instances`"
  type        = any
  default     = {}
}

variable "backup_retention_period" {
  description = "Retention period (in days) to retain database backups"
  type        = number
  default     = 7
}

variable "cluster_master_username" {
  description = "Username to configure on the cluster"
  type        = string
  default     = "clusteradmin"
}

variable "db_parameter_group_parameter_overrides" {
  description = "Can be used to override `local.db_parameter_group_parameters`"
  type        = any
  default     = {}
}

variable "db_cluster_parameter_group_parameter_overrides" {
  description = "Can be used to override `local.cluster_parameter_group_parameters`"
  type        = any
  default     = {}
}

variable "tag_overrides" {
  description = "Map of key/values pairs, which can be used to override/set new tags on resources"
  type        = any
  default     = {}
}

variable "cluster_apply_immediately" {
  description = "Enable/disable immediate application of updates to cluster"
  type        = bool
  default     = false
}

variable "cluster_skip_final_snapshot" {
  description = "Enable/disable the creation of a final snapshot on cluster deletion"
  type        = bool
  default     = true
}

variable "cluster_deletion_protection" {
  description = "Enable/disable deletion protection on the cluster"
  type        = bool
  default     = true
}

variable "cluster_preferred_maintenance_window" {
  description = "Maintenance window to apply cluster changes on, in UTC"
  type        = string
  default     = "sat:11:15-sat:11:45"
}

variable "cluster_performance_insights_enabled" {
  description = "Enable/disable Performance Insights"
  type        = bool
  default     = true
}

variable "performance_insights_kms_key_arn" {
  description = "KMS key for Performance Insights"
  type        = string
  default     = null
}

variable "cluster_snapshot_identifier" {
  description = "Can be used to pass in an existing database snapshot"
  type        = string
  default     = null
}

variable "cluster_min_capacity" {
  description = "Minimum ACU count that can be allocated to each cluster instance"
  type        = number
  default     = 1
}

variable "cluster_max_capacity" {
  description = "Maxnimum ACU count that can be allocated to each cluster instance"
  type        = number
  default     = 4
}
