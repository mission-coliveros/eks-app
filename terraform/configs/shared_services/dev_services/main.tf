locals {
  global_variables = yamldecode(file("../../../global_variables.yaml"))
  shared_variables = data.terraform_remote_state.shared.outputs["shared_variables"]
  resource_prefix  = "${var.org_name}-${var.stack_name}-${terraform.workspace}"
}
