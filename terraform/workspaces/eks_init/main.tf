locals {
  resource_prefix             = "${var.org_name}-${var.stack_name}-${terraform.workspace}"
  global_variables            = yamldecode(file("../../global_variables.yaml"))
  shared_variables            = data.terraform_remote_state.shared.outputs["shared_variables"]
  kms_key_arns                = data.terraform_remote_state.product["core"].outputs["kms_key_arns"]
  terraform_state_bucket      = local.global_variables["terraform_state"]
}

# ----------------------------------------------------------------------------------------------------------------------
# EKS addons
# ----------------------------------------------------------------------------------------------------------------------

module "eks_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16.0"

  cluster_name                = local.compute["cluster_name"]
  cluster_version             = var.eks_cluster_version
  cluster_endpoint            = local.compute["cluster_endpoint"]
  oidc_provider_arn           = local.compute["cluster_oidc_provider_arn"]
  create_kubernetes_resources = false

  tags = {
    "karpenter.sh/discovery" = local.compute["cluster_name"]
    "terraform:module"       = "eks_addons"
  }

  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }

    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        computeType = "Fargate"
        resources = {
          limits = {
            cpu    = "0.25"
            memory = "256M"
          }
          requests = {
            cpu    = "0.25"
            memory = "256M"
          }
        }
      })
    }

    kube-proxy = { most_recent = true }

    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        enableWindowsIpam = "true"
      })
    }

  }

  # --------------------------------------------------------------------------------------------------------------------
  # Karpenter
  # --------------------------------------------------------------------------------------------------------------------

#  enable_karpenter                           = true
#  karpenter_enable_instance_profile_creation = true
#  karpenter = {
#    chart_version        = "v0.33.1"
#    role_name            = "${local.compute["cluster_name"]}-irsa-aws-karpenter-controller"
#    role_name_use_prefix = false
#  }
#  karpenter_node = {
#    iam_role_name                = "${local.compute["cluster_name"]}-irsa-aws-karpenter-node"
#    iam_role_use_name_prefix     = false
#    iam_role_additional_policies = { AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" }
#    service_account_name         = "irsa-aws-karpenter"
#  }

  # --------------------------------------------------------------------------------------------------------------------
  # AWS Load Balancer Controller
  # --------------------------------------------------------------------------------------------------------------------

  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    role_name            = "${local.compute["cluster_name"]}-irsa-aws-load-balancer-controller"
    role_name_use_prefix = false
    service_account_name = "irsa-aws-load-balancer-controller"

    values = [jsonencode({ vpcId = local.network["vpc_id"] })]
  }

  # --------------------------------------------------------------------------------------------------------------------
  # AWS FSx CSI Driver
  # --------------------------------------------------------------------------------------------------------------------

  enable_aws_fsx_csi_driver = true

  aws_fsx_csi_driver = {
    repository    = "https://kubernetes-sigs.github.io/aws-fsx-openzfs-csi-driver/"
    chart         = "aws-fsx-openzfs-csi-driver"
    chart_version = "1.1.0"

    role_name                       = "${local.compute["cluster_name"]}-irsa-aws-fsx-openzfs-csi-driver"
    role_name_use_prefix            = false
    controller_service_account_name = "irsa-aws-fsx-openzfs-csi-driver-controller"
    node_service_account_name       = "irsa-aws-fsx-openzfs-csi-driver-node"
  }

  # --------------------------------------------------------------------------------------------------------------------
  # External Secrets Operator (Helm chart)
  # --------------------------------------------------------------------------------------------------------------------

  enable_external_secrets = true
  external_secrets_helm_config = {
    values = [
      jsonencode({
        name  = "installCRDs",
        value = "true"
      })
    ]
  }

  # --------------------------------------------------------------------------------------------------------------------
  # Other
  # --------------------------------------------------------------------------------------------------------------------

  enable_kube_prometheus_stack = false
  enable_metrics_server        = true
  enable_cert_manager          = false

}

#resource "kubernetes_config_map_v1" "aws_resource_ids" {
#  metadata {
#    name = "aws-resource-ids"
#  }
#
#  data = {
#    eks_cluster_name = local.compute["cluster_name"]
#    eks_cluster_arn  = local.compute["cluster_arn"]
#
#    vpc_id              = local.network["vpc_id"]
#    public_subnet_ids   = jsonencode(local.network["vpc_subnet_ids"]["public"])
#    private_subnet_ids  = jsonencode(local.network["vpc_subnet_ids"]["private"])
#    database_subnet_ids = jsonencode(local.network["vpc_subnet_ids"]["database"])
#    cache_subnet_ids    = jsonencode(local.network["vpc_subnet_ids"]["cache"])
#
#    database_psql_arn             = local.datastores["database_psql_cluster_arn"]
#    database_psql_id              = local.datastores["database_psql_cluster_id"]
#    database_psql_endpoint        = local.datastores["database_psql_cluster_endpoint"]
#    database_psql_reader_endpoint = local.datastores["database_psql_cluster_reader_endpoint"]
#
#    cache_redis_arn      = local.datastores["elasticache_cluster_arn"]
#    cache_redis_dns_name = local.datastores["elasticache_cluster_endpoint"]
#
#    activemq_broker_arn      = local.datastores["activemq_broker_arn"]
#    activemq_broker_id       = local.datastores["activemq_broker_id"]
#    activemq_broker_dns_name = local.datastores["activemq_broker_endpoints"]
#
#    openzfs_filesystem_id       = local.datastores["openzfs_file_system_id"]
#    openzfs_filesystem_dns_name = local.datastores["database_psql_cluster_endpoint"]
#  }
#}