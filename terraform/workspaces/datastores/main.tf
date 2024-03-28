locals {
  resource_prefix = "${var.org_name}-${var.stack_name}-${terraform.workspace}"

  global_variables = yamldecode(file("../../global_variables.yaml"))
  shared_variables = data.terraform_remote_state.shared.outputs["shared_variables"]

  network      = data.terraform_remote_state.product["network"].outputs
  kms_key_arns = data.terraform_remote_state.product["core"].outputs["kms_key_arns"]

  active_availability_zones = var.active_availability_zones != null ? var.active_availability_zones : length(var.availability_zones)
}

# ----------------------------------------------------------------------------------------------------------------------
# ActiveMQ broker
# ----------------------------------------------------------------------------------------------------------------------

module "activemq" {
  source = "../../modules/activemq"

  resource_prefix                  = local.resource_prefix
  security_groups                  = [local.network["security_group_ids"]["activemq_broker"]]
  subnet_ids                       = [local.network["vpc_subnet_ids"]["private"][0]]
  secrets_manager_kms_key_arn      = local.kms_key_arns["secrets-manager"]
}

# ----------------------------------------------------------------------------------------------------------------------
# PostgreSQL Aurora cluster
# ----------------------------------------------------------------------------------------------------------------------

module "psql_database" {
  source = "../../modules/aurora_cluster"

  cluster_name = "${local.resource_prefix}-psql"
  # cluster_engine_full_version = "8.0.mysql_aurora.3.04.0"

  cluster_availability_zones = slice(local.network["availability_zones"], 0, (local.active_availability_zones))
  cluster_security_group_ids = [local.network["security_group_ids"]["db_psql_cluster"]]
  cluster_vpc_id             = local.network["vpc_id"]
  cluster_subnets            = local.network["vpc_subnet_ids"]["database"]

  cluster_kms_key_id               = local.kms_key_arns["rds"]
  secrets_manager_kms_key_arn      = local.kms_key_arns["secrets-manager"]
  performance_insights_kms_key_arn = local.kms_key_arns["logs"]
}

# ----------------------------------------------------------------------------------------------------------------------
# Redis cache
# ----------------------------------------------------------------------------------------------------------------------

module "elasticache_redis" {
  source = "../../modules/elasticache_redis"

  # Base
  resource_prefix = local.resource_prefix

  # Network
  subnet_ids                 = local.network["vpc_subnet_ids"]["cache"]
  vpc_id                     = local.network["vpc_id"]
  cluster_security_group_ids = [local.network["security_group_ids"]["cache_redis_cluster"]]

  # Security
  kms_key_id = local.kms_key_arns["elasticache"]

}

# ----------------------------------------------------------------------------------------------------------------------
# OpenZFS filesystem
# ----------------------------------------------------------------------------------------------------------------------

locals {
  zfs_volumes = {}
}

module "merged_zfs_volumes" {
  source  = "cloudposse/config/yaml//modules/deepmerge"
  version = "~> 1.0.2"

  maps = [local.zfs_volumes, var.zfs_volume_overrides]
}

module "openzfs_filesystem" {
  source = "../../modules/openzfs_filesystem"

  filesystem_storage_capacity = 100
  resource_prefix = local.resource_prefix
  security_group_ids = [local.network["security_group_ids"]["fs_openzfs_server"]]
  subnet_ids = [local.network["vpc_subnet_ids"]["private"][0]]
  filesystem_volumes = module.merged_zfs_volumes.merged

  tags = {
    "subsystem:storage" = ""
  }
}
