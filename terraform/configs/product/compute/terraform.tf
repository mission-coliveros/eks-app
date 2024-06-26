terraform {
  required_version = ">= 1.7"

  backend "s3" {
    region               = "us-west-2"
    bucket               = "cmoliveros-terraform-state"
    workspace_key_prefix = "product/main"
    key                  = "compute.tfstate"
    encrypt              = true
    dynamodb_table       = "terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27.0"
    }
  }

}
