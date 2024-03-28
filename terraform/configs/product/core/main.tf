locals {
  resource_prefix             = "${var.org_name}-${var.stack_name}-${terraform.workspace}"

  global_variables = yamldecode(file("../../../global_variables.yaml"))
  shared_variables = data.terraform_remote_state.shared.outputs["shared_variables"]
}

data "aws_iam_role" "autoscaling_service" {
  name = "AWSServiceRoleForAutoScaling"
}

module "kms" {
  # Default keys: [cloudtrail, ebs, efs, glue, logs, rds, s3, systems-manager, secrets-manager, sns, ses, sqs]
  source = "../../../modules/kms_key_suite"

  environment_name               = terraform.workspace
  autoscaling_service_role_arn   = data.aws_iam_role.autoscaling_service.arn
  set_ebs_default_encryption_key = false

  kms_key_overrides = {
    glue = { create = false }
    ses  = { create = false }
  }

  key_administrator_groups             = local.shared_variables["kms"]["key_administrator_groups"]
  key_administrator_roles              = local.shared_variables["kms"]["key_administrator_roles"]
  key_owner_groups                     = local.shared_variables["kms"]["key_owner_groups"]
  key_owner_roles                      = local.shared_variables["kms"]["key_owner_roles"]
  key_symmetric_encryption_user_groups = local.shared_variables["kms"]["key_symmetric_encryption_user_groups"]
  key_symmetric_encryption_user_roles  = local.shared_variables["kms"]["key_symmetric_encryption_user_roles"]
}
