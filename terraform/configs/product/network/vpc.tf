module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7.0"

  name = local.resource_prefix
  azs  = var.availability_zones

  cidr                = local.cidrs["vpc"]
  private_subnets     = try(local.cidrs["private_subnets"], [])
  public_subnets      = try(local.cidrs["public_subnets"], [])
  elasticache_subnets = try(local.cidrs["cache_subnets"], [])
  database_subnets    = try(local.cidrs["database_subnets"], [])
  intra_subnets       = try(local.cidrs["intra_subnets"], [])
  redshift_subnets    = try(local.cidrs["redshift_subnets"], [])

  enable_nat_gateway      = true
  single_nat_gateway      = var.single_nat_gateway
  map_public_ip_on_launch = true

  # Flow logs
  enable_flow_log                                 = var.enable_flow_log
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_name_suffix       = local.resource_prefix
  flow_log_cloudwatch_log_group_kms_key_id        = local.kms_key_arns["logs"]
  flow_log_cloudwatch_log_group_retention_in_days = 365
  flow_log_max_aggregation_interval               = 60

  # Default security group
  default_security_group_name = "${local.resource_prefix}-default"
  default_security_group_tags = { Name = "${local.resource_prefix}-default" }
  default_security_group_ingress = [
    {
      cidr_blocks = local.vpc_cidr
      description = "Allow inbound traffic from VPC CIDR"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    },
  ]
  default_security_group_egress = [
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Default"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    },
    {
      cidr_blocks = "0.0.0.0/0"
      description = "Default"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
    }
  ]

  tags = {
    "kubernetes.io/cluster/${local.resource_prefix}" = "shared"
    "terraform_module"                               = "vpc"
  }

  # Tags
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery"          = local.resource_prefix
  }

}
