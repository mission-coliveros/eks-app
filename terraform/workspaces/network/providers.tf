provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      environment         = terraform.workspace
      aws_region          = var.aws_region
      terraform_config    = var.stack_name
      system_name         = "${local.resource_prefix}-${var.aws_region}"
      "subsystem:network" = ""
    }
  }

  ignore_tags { keys = ["CreatorId", "mission:Owner"] }
}
