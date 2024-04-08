locals {
  kms_key_arns = data.terraform_remote_state.product["core"].outputs["kms_key_arns"]
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
  for_each = toset(["core"])

  backend = "s3"
  config = {
    region = local.global_variables["terraform_state"]["primary_region"]
    bucket = local.global_variables["terraform_state"]["bucket_name"]
    key    = "product/main/${terraform.workspace}/${each.value}.tfstate"
  }
}
