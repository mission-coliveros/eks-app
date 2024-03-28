locals {
  merged_security_groups = module.merged_security_groups.merged

  security_groups = {
    activemq_broker = { description = "ActiveMQ broker" }
    activemq_client = {
      description = "Clients of ActiveMQ broker"
      tags = {
        "karpenter.sh/discovery" = local.resource_prefix
        "karpenter.sh/nodeClass" = "linux"
      }
    }

    cache_redis_client  = { description = "Clients of Redis cache" }
    cache_redis_cluster = { description = "Redis cache" }

    compute_eks_cluster = {
      description = "EKS cluster node group"
      tags = {
        "kubernetes.io/cluster/${local.resource_prefix}" = "owned"
      }
    }

    compute_eks_node_group_base = {
      description = "Base node group for compute nodes"
      tags = {
        "karpenter.sh/discovery" = local.resource_prefix
        "karpenter.sh/nodeClass" = "base"
      }
    }

    compute_eks_node_group_linux = {
      description = "Default node group for compute nodes"
      tags = {
        "karpenter.sh/discovery" = local.resource_prefix
        "karpenter.sh/nodeClass" = "linux"
      }
    }

    db_psql_client = {
      description = "Clients of PostgreSQL database"
      tags = {
        "karpenter.sh/discovery" = local.resource_prefix
        "karpenter.sh/nodeClass" = "base"
      }
    }

    db_psql_cluster = { description = "PostgreSQL database" }

    fs_openzfs_client = {
      description = "Clients of the FSx OpenZFS network drive"
      tags = {
        "karpenter.sh/discovery" = local.resource_prefix
        "karpenter.sh/nodeClass" = "base"
      }
    }

    fs_openzfs_server = { description = "FSx OpenZFS network drive" }

    route_53_resolvers = { description = "Route 53 resolver endpoints" }

    vpc_endpoints = { description = "AWS VPC Endpoints" }
  }
}

# ----------------------------------------------------------------------------------------------------------------------

module "merged_security_groups" {
  source  = "cloudposse/config/yaml//modules/deepmerge"
  version = "~> 1.0.2"

  maps = [local.security_groups, var.security_group_overrides]
}

resource "aws_security_group" "this" {
  for_each = local.merged_security_groups

  vpc_id                 = module.vpc.vpc_id
  name                   = "${local.resource_prefix}-${replace(each.key, "_", "-")}"
  description            = each.value["description"]
  revoke_rules_on_delete = true

  tags = merge(
    {
      Name = "${local.resource_prefix}-${replace(each.key, "_", "-")}"
    },
    lookup(each.value, "tags", {})
  )

  timeouts {
    create = "10m"
    delete = "15m"
  }

}
