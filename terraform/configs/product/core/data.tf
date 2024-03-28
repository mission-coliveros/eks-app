data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    region = local.global_variables["terraform_state"]["primary_region"]
    bucket = local.global_variables["terraform_state"]["bucket_name"]
    key    = "shared-services/prod/terraform.tfstate"
  }
}