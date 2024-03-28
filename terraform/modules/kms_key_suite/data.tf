data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_role" "kms_key_administrators" {
  for_each = toset(var.key_administrator_roles)
  name     = each.value
}

data "aws_iam_role" "kms_key_owners" {
  for_each = toset(var.key_owner_roles)
  name     = each.value
}

data "aws_iam_role" "kms_key_symmetric_encryption_users" {
  for_each = toset(var.key_symmetric_encryption_user_roles)
  name     = each.value
}

data "aws_iam_group" "kms_key_administrators" {
  for_each   = toset(var.key_administrator_groups)
  group_name = each.value
}

data "aws_iam_group" "kms_key_owners" {
  for_each   = toset(var.key_owner_groups)
  group_name = each.value
}

data "aws_iam_group" "kms_key_symmetric_encryption_users" {
  for_each   = toset(var.key_symmetric_encryption_user_groups)
  group_name = each.value
}

locals {
  aws_account_id   = data.aws_caller_identity.current.account_id
  aws_account_root = "arn:aws:iam::${local.aws_account_id}:root"
  aws_region       = data.aws_region.current.name

  default_key_administrators = concat(
    values(data.aws_iam_role.kms_key_administrators)[*].arn,
    values(data.aws_iam_group.kms_key_administrators)[*].arn
  )
  default_key_owners = concat(
    values(data.aws_iam_role.kms_key_owners)[*].arn,
    values(data.aws_iam_group.kms_key_owners)[*].arn
  )
  default_key_symmetric_encryption_users = concat(
    values(data.aws_iam_role.kms_key_symmetric_encryption_users)[*].arn,
    values(data.aws_iam_group.kms_key_symmetric_encryption_users)[*].arn
  )
}
