locals {

  cluster_instances = {
    for i in var.cluster_availability_zones : i => {
      identifier            = "${var.cluster_name}-${i}"
      availability_zone     = i
      copy_tags_to_snapshot = false
      instance_class        = "db.serverless"
      promotion_tier        = 1
      publicly_accessible   = false
    }
  }

  db_cluster_parameter_group_parameters = {}

  db_parameter_group_parameters = {}

  tags = merge({}, var.tag_overrides)
}

module "merged_db_cluster_parameter_group_parameters" {
  source = "cloudposse/config/yaml//modules/deepmerge"
  maps   = [local.db_cluster_parameter_group_parameters, var.db_cluster_parameter_group_parameter_overrides]
}

module "merged_db_parameter_group_parameters" {
  source = "cloudposse/config/yaml//modules/deepmerge"
  maps   = [local.db_parameter_group_parameters, var.db_parameter_group_parameter_overrides]
}

module "merged_cluster_instances" {
  source = "cloudposse/config/yaml//modules/deepmerge"
  maps   = [local.cluster_instances, var.cluster_instance_overrides]
}
