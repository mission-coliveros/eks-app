locals {
  resource_prefix        = "${var.org_name}-${var.stack_name}-${terraform.workspace}"
  global_variables       = yamldecode(file("../../../global_variables.yaml"))
  shared_variables       = data.terraform_remote_state.shared.outputs["shared_variables"]
  kms_key_arns           = data.terraform_remote_state.product["core"].outputs["kms_key_arns"]
  terraform_state_bucket = local.global_variables["terraform_state"]
}
