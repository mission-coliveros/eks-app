# ----------------------------------------------------------------------------------------------------------------------
# For a list of supported quick rules, visit the link below:
# https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf
# ----------------------------------------------------------------------------------------------------------------------

locals {
  all_cidr_blocks = "0.0.0.0/0"

  security_group_rules = {

    activemq_broker = {
      ingress_with_source_security_group_id = [
        {
          description              = "sg-activemq_client: ActiveMQ AMQP traffic"
          rule                     = "activemq-5671-tcp"
          source_security_group_id = aws_security_group.this["activemq_client"].id
        },
        {
          description              = "sg-activemq_client: ActiveMQ MQTT traffic"
          rule                     = "activemq-8883-tcp"
          source_security_group_id = aws_security_group.this["activemq_client"].id
        },
        {
          description              = "sg-activemq_client: ActiveMQ STOMP traffic"
          rule                     = "activemq-61614-tcp"
          source_security_group_id = aws_security_group.this["activemq_client"].id
        },
        {
          description              = "sg-activemq_client: ActiveMQ OpenWire traffic"
          rule                     = "activemq-61617-tcp"
          source_security_group_id = aws_security_group.this["activemq_client"].id
        },
        {
          description              = "sg-activemq_client: ActiveMQ WebSocket traffic"
          rule                     = "activemq-61619-tcp"
          source_security_group_id = aws_security_group.this["activemq_client"].id
        }
      ]
    }
    activemq_client = {
      egress_with_source_security_group_id = [
        {
          description              = "sg-activemq_broker: ActiveMQ AMQP traffic"
          rule                     = "activemq-5671-tcp"
          source_security_group_id = aws_security_group.this["activemq_broker"].id
        },
        {
          description              = "sg-activemq_broker: ActiveMQ MQTT traffic"
          rule                     = "activemq-8883-tcp"
          source_security_group_id = aws_security_group.this["activemq_broker"].id
        },
        {
          description              = "sg-activemq_broker: ActiveMQ STOMP traffic"
          rule                     = "activemq-61614-tcp"
          source_security_group_id = aws_security_group.this["activemq_broker"].id
        },
        {
          description              = "sg-activemq_broker: ActiveMQ OpenWire traffic"
          rule                     = "activemq-61617-tcp"
          source_security_group_id = aws_security_group.this["activemq_broker"].id
        },
        {
          description              = "sg-activemq_broker: ActiveMQ WebSocket traffic"
          rule                     = "activemq-61619-tcp"
          source_security_group_id = aws_security_group.this["activemq_broker"].id
        }
      ]
    }

    cache_redis_client = {
      egress_with_source_security_group_id = [
        {
          description              = "sg-cache_redis_cluster: Redis traffic"
          rule                     = "redis-tcp"
          source_security_group_id = aws_security_group.this["cache_redis_client"].id
        }
      ]
    }

    cache_redis_cluster = {
      ingress_with_source_security_group_id = [
        {
          description              = "sg-cache_redis_client: Redis traffic"
          rule                     = "redis-tcp"
          source_security_group_id = aws_security_group.this["cache_redis_cluster"].id
        }
      ]
    }

    compute_eks_cluster = {
      ingress_with_source_security_group_id = [
        {
          description              = "cidr-vpc: https-443-tcp"
          rule                     = "https-443-tcp"
          source_security_group_id = aws_security_group.this["compute_eks_node_group_base"].id
        }
      ]
    }

    compute_eks_node_group_base = {

      ingress_with_source_security_group_id = [
        {
          description              = "sg-compute_eks_cluster: https-443-tcp"
          rule                     = "https-443-tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: 4443-tcp"
          from_port                = 4443
          to_port                  = 4443
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: kubernetes-api-tcp"
          rule                     = "kubernetes-api-tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: https-8443-tcp"
          rule                     = "https-8443-tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: 9443-tcp"
          from_port                = 9443
          to_port                  = 9443
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: 10250-tcp"
          from_port                = 10250
          to_port                  = 10250
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: 53-tcp"
          from_port                = 53
          to_port                  = 53
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: 53-udp"
          from_port                = 53
          to_port                  = 53
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        },
        {
          description              = "sg-compute_eks_cluster: 1025-65535"
          from_port                = 1025
          to_port                  = 65535
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["compute_eks_cluster"].id
        }
      ]

      ingress_with_cidr_blocks = [
        {
          description = "cidr-vpc: all-all"
          rule        = "all-all"
          cidr_blocks = module.vpc.vpc_cidr_block
        }
      ]

      egress_with_cidr_blocks = [
        {
          description = "cidr-all: all-all"
          rule        = "all-all"
          cidr_blocks = local.all_cidr_blocks
        }
      ]

    }

    compute_eks_node_group_linux = {}

    fs_openzfs_client = {
      egress_with_source_security_group_id = [
        {
          description              = "sg-fs_openzfs_server: RPC"
          from_port                = 111
          to_port                  = 111
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_server"].id
        },
        {
          description              = "sg-fs_openzfs_server: RPC"
          from_port                = 111
          to_port                  = 111
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_server"].id
        },
        {
          description              = "sg-fs_openzfs_server: Server daemon"
          from_port                = 2049
          to_port                  = 2049
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_server"].id
        },
        {
          description              = "sg-fs_openzfs_server: Server daemon"
          from_port                = 2049
          to_port                  = 2049
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_server"].id
        },
        {
          description              = "sg-fs_openzfs_server: NFS mount, status monitor, and lock daemon"
          from_port                = 20001
          to_port                  = 20003
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_server"].id
        },
        {
          description              = "sg-fs_openzfs_server: NFS mount, status monitor, and lock daemon"
          from_port                = 20001
          to_port                  = 20003
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_server"].id
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------

    fs_openzfs_server = {
      ingress_with_source_security_group_id = [
        {
          description              = "Remote procedure call for NFS"
          from_port                = 111
          to_port                  = 111
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "Remote procedure call for NFS"
          from_port                = 111
          to_port                  = 111
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS server daemon"
          from_port                = 2049
          to_port                  = 2049
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS server daemon"
          from_port                = 2049
          to_port                  = 2049
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS mount, status monitor, and lock daemon"
          from_port                = 20001
          to_port                  = 20003
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS mount, status monitor, and lock daemon"
          from_port                = 20001
          to_port                  = 20003
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        }
      ]

      egress_with_source_security_group_id = [
        {
          description              = "Remote procedure call for NFS"
          from_port                = 111
          to_port                  = 111
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "Remote procedure call for NFS"
          from_port                = 111
          to_port                  = 111
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS server daemon"
          from_port                = 2049
          to_port                  = 2049
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS server daemon"
          from_port                = 2049
          to_port                  = 2049
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS mount, status monitor, and lock daemon"
          from_port                = 20001
          to_port                  = 20003
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        },
        {
          description              = "NFS mount, status monitor, and lock daemon"
          from_port                = 20001
          to_port                  = 20003
          protocol                 = "udp"
          source_security_group_id = aws_security_group.this["fs_openzfs_client"].id
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------

    route_53_resolvers = {

      ingress_with_cidr_blocks = [
        {
          description = "cidr-vpc: dns-tcp"
          rule        = "dns-tcp"
          cidr_blocks = module.vpc.vpc_cidr_block
        },
        {
          description = "cidr-vpc: dns-udp"
          rule        = "dns-udp"
          cidr_blocks = module.vpc.vpc_cidr_block
        }
      ]

      egress_with_cidr_blocks = [
        {
          description = "cidr-vpc: dns-tcp"
          rule        = "dns-tcp"
          cidr_blocks = module.vpc.vpc_cidr_block
        },
        {
          description = "cidr-vpc: dns-udp"
          rule        = "dns-udp"
          cidr_blocks = module.vpc.vpc_cidr_block
        }
      ]

    }

    # ------------------------------------------------------------------------------------------------------------------

    db_psql_cluster = {
      ingress_with_source_security_group_id = [
        {
          description              = "sg-db_psql_client: Database traffic"
          from_port                = 6819
          to_port                  = 6819
          protocol                 = "tcp"
          source_security_group_id = aws_security_group.this["db_psql_client"].id
        },
        {
          description              = "sg-db_psql_client: Database traffic"
          rule                     = "postgresql-tcp"
          source_security_group_id = aws_security_group.this["db_psql_client"].id
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------

    db_psql_client = {
      egress_with_source_security_group_id = [
        {
          description              = "sg-db_psql: Database traffic"
          rule                     = "postgresql-tcp"
          source_security_group_id = aws_security_group.this["db_psql_cluster"].id
        }
      ]

      egress_with_cidr_blocks = [
        {
          description = "cidr-all: all-all"
          rule        = "all-all"
          cidr_blocks = "0.0.0.0/0"
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------

    vpc_endpoints = {
      ingress_with_cidr_blocks = [
        {
          description = "cidr-vpc: https-443-tcp"
          rule        = "https-443-tcp"
          cidr_blocks = module.vpc.vpc_cidr_block
        }
      ]

      ingress_with_self = [
        {
          description = "sg-self: all-tcp"
          rule        = "all-tcp"
        }
      ]

      ingress_with_source_security_group_id = []

      egress_with_cidr_blocks = [
        {
          description = "cidr-all: all-tcp"
          rule        = "all-tcp"
          cidr_blocks = local.all_cidr_blocks
        }
      ]
    }

  }
}

module "merged_security_group_rules" {
  source  = "cloudposse/config/yaml//modules/deepmerge"
  version = "~> 1.0.2"

  maps = [local.security_group_rules, var.security_group_rule_overrides]
}

module "security_group_rules" {
  for_each = module.merged_security_group_rules.merged
  source   = "terraform-aws-modules/security-group/aws"
  version  = "~> 5.1.2"

  create_sg         = false
  security_group_id = aws_security_group.this[each.key].id

  ingress_with_self                     = lookup(module.merged_security_group_rules.merged[each.key], "ingress_with_self", [])
  ingress_with_source_security_group_id = lookup(module.merged_security_group_rules.merged[each.key], "ingress_with_source_security_group_id", [])
  ingress_with_cidr_blocks              = lookup(module.merged_security_group_rules.merged[each.key], "ingress_with_cidr_blocks", [])
  ingress_rules                         = lookup(module.merged_security_group_rules.merged[each.key], "ingress_rules", [])
  ingress_prefix_list_ids               = lookup(module.merged_security_group_rules.merged[each.key], "ingress_prefix_list_ids", [])
  ingress_with_prefix_list_ids          = lookup(module.merged_security_group_rules.merged[each.key], "ingress_with_prefix_list_ids", [])


  egress_with_self                     = lookup(module.merged_security_group_rules.merged[each.key], "egress_with_self", [])
  egress_with_source_security_group_id = lookup(module.merged_security_group_rules.merged[each.key], "egress_with_source_security_group_id", [])
  egress_with_cidr_blocks              = lookup(module.merged_security_group_rules.merged[each.key], "egress_with_cidr_blocks", [])
  egress_rules                         = lookup(module.merged_security_group_rules.merged[each.key], "egress_rules", [])
  egress_prefix_list_ids               = lookup(module.merged_security_group_rules.merged[each.key], "egress_prefix_list_ids", [])
  egress_with_prefix_list_ids          = lookup(module.merged_security_group_rules.merged[each.key], "egress_with_prefix_list_ids", [])
}
