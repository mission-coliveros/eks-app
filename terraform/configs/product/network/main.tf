locals {
  resource_prefix = "${var.org_name}-${var.stack_name}-${terraform.workspace}"

  global_variables = yamldecode(file("../../../global_variables.yaml"))
  shared_variables = data.terraform_remote_state.shared.outputs["shared_variables"]
  networks         = local.shared_variables["networks"]

  cidrs    = local.networks["cidrs"]["aws"]["product"]["main"][terraform.workspace]
  vpc_cidr = local.cidrs["vpc"]
}
