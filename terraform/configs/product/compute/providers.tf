provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      environment      = terraform.workspace
      stack_name       = var.stack_name
      region           = var.aws_region
      terraform_config = "compute"
      system_name      = "${local.resource_prefix}-${var.aws_region}"
    }
  }

  ignore_tags { keys = ["CreatorId", "mission:Owner"] }
}

provider "kubernetes" {
  host                   = module.eks_cluster["cluster_endpoint"]
  cluster_ca_certificate = base64decode(module.eks_cluster["cluster_certificate_authority_data"])
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_cluster["cluster_endpoint"]
    cluster_ca_certificate = base64decode(module.eks_cluster["cluster_certificate_authority_data"])
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
