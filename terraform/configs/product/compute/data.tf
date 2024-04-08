locals {
  datastores = data.terraform_remote_state.product["datastores"].outputs
  network    = data.terraform_remote_state.product["network"].outputs
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    region = local.global_variables["terraform_state"]["primary_region"]
    bucket = local.global_variables["terraform_state"]["bucket_name"]
    key    = "shared-services/prod/main.tfstate"
  }
}

data "terraform_remote_state" "product" {
  for_each = toset(["core", "datastores", "network"])

  backend = "s3"
  config = {
    region = local.global_variables["terraform_state"]["primary_region"]
    bucket = local.global_variables["terraform_state"]["bucket_name"]
    key    = "product/main/${terraform.workspace}/${each.value}.tfstate"
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks_cluster.cluster_name
}