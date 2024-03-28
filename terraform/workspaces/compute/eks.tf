locals {
  cluster_name              = coalesce(var.eks_cluster_name_override, local.resource_prefix)
  active_availability_zones = var.active_availability_zones != null ? var.active_availability_zones : length(var.availability_zones)
}

module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8.3"

  cluster_version = var.eks_cluster_version
  cluster_name    = local.cluster_name

  # Network
  vpc_id                         = local.network["vpc_id"]
  subnet_ids                     = slice(local.network["vpc_subnet_ids"]["private"], 0, local.active_availability_zones + 1)
  cluster_endpoint_public_access = true

  cluster_security_group_id                    = local.network["security_group_ids"]["compute_eks_cluster"]
  node_security_group_id                       = local.network["security_group_ids"]["compute_eks_node_group_base"]
  create_cluster_security_group                = false
  cluster_security_group_use_name_prefix       = false
  create_node_security_group                   = false
  node_security_group_enable_recommended_rules = false

  fargate_profiles = {
    karpenter = {
      iam_role_name            = "${local.cluster_name}-fargate-profile-karpenter"
      iam_role_use_name_prefix = false
      selectors                = [{ namespace = "karpenter" }]
    }
    kube-system = {
      iam_role_name            = "${local.cluster_name}-fargate-profile-kube-system"
      iam_role_use_name_prefix = false
      selectors                = [{ namespace = "kube-system" }]
    }
  }

  tags = {
    "karpenter.sh/discovery" = local.cluster_name
    "terraform:module"       = "eks_cluster"
  }
}

module "eks_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = false

  aws_auth_roles = [
    {
      rolearn  = "AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"
      username = "AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"
      username = "AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"
      groups   = ["system:masters"]
    }
  ]

}

module "eks_roles" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.0"

  cluster_name                = module.eks_cluster.cluster_name
  cluster_version             = var.eks_cluster_version
  cluster_endpoint            = module.eks_cluster.cluster_endpoint
  oidc_provider_arn           = module.eks_cluster.oidc_provider_arn

  # --------------------------------------------------------------------------------------------------------------------
  # Karpenter
  # --------------------------------------------------------------------------------------------------------------------

  enable_karpenter                           = true
  karpenter_enable_instance_profile_creation = true
  karpenter = {
    role_name            = "${module.eks_cluster.cluster_name}-irsa-aws-karpenter-controller"
    role_name_use_prefix = false
  }
  karpenter_node = {
    iam_role_name                = "${module.eks_cluster.cluster_name}-irsa-aws-karpenter-node"
    iam_role_use_name_prefix     = false
    iam_role_additional_policies = { AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" }
  }

}