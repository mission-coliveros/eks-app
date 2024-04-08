locals {
  # enabled_keys = { for k, v in module.merged_kms_key_specs.merged : k => v if v["create"] }
}

module "kms" {
  for_each = module.merged_kms_key_specs.merged
  source   = "terraform-aws-modules/kms/aws"
  version  = "~> 1.5.0"

  create                            = lookup(each.value, "create", var.default_create)
  is_enabled                        = lookup(each.value, "is_enabled", var.default_is_enabled)
  aliases                           = lookup(each.value, "aliases", ["${var.environment_name}/${each.key}"])
  deletion_window_in_days           = lookup(each.value, "deletion_window_in_days", var.default_deletion_window_in_days)
  description                       = lookup(each.value, "description", "Supports AWS ${title(each.key)} service/s")
  enable_default_policy             = lookup(each.value, "enable_default_policy", var.default_enable_default_policy)
  enable_key_rotation               = lookup(each.value, "enable_key_rotation", var.default_enable_key_rotation)
  grants                            = lookup(each.value, "grants", {})
  key_service_roles_for_autoscaling = lookup(each.value, "key_service_roles_for_autoscaling", [])
  multi_region                      = lookup(each.value, "multi_region", var.default_multi_region)
  key_usage                         = lookup(each.value, "key_usage", "ENCRYPT_DECRYPT")

  key_statements = concat(
    lookup(each.value, "key_statements", []),
    length(lookup(each.value, "allowed_services", [])) > 0 ? [
      jsondecode(templatefile(
        "${path.module}/assets/iam/root_policy.json.tftpl",
        {
          allowed_accounts = jsonencode(compact(concat(
            [local.aws_account_id],
            lookup(each.value, "allowed_external_accounts", [])
            ))
          )
          allowed_services = jsonencode([for s in each.value["allowed_services"] : "${s}.amazonaws.com"])
        }
      ))
    ] : []
  )

  key_administrators = concat(
    lookup(each.value, "key_administrators", []),
    lookup(each.value, "include_default_key_administrators", true) ? local.default_key_administrators : []
  )

  key_owners = concat(
    lookup(each.value, "key_owners", []),
    lookup(each.value, "include_default_key_owners", true) ? local.default_key_owners : []
  )

  key_symmetric_encryption_users = concat(
    lookup(each.value, "key_symmetric_encryption_users", []),
    lookup(each.value, "include_default_key_symmetric_encryption_users", true) ? local.default_key_symmetric_encryption_users : []
  )

}

resource "aws_ebs_encryption_by_default" "this" {
  count   = var.set_ebs_default_encryption_key ? 1 : 0
  enabled = true
}

resource "aws_ebs_default_kms_key" "this" {
  count   = var.set_ebs_default_encryption_key ? 1 : 0
  key_arn = module.kms["ebs"].key_arn
}
