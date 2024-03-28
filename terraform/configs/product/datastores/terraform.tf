terraform {
  required_version = ">= 1.5"

  backend "s3" {
    region               = "us-west-2"
    bucket               = "cmoliveros-terraform-state"
    workspace_key_prefix = "product/main"
    key                  = "datastores.tfstate"
    encrypt              = true
    dynamodb_table       = "terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

}