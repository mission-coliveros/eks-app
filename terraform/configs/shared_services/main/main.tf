locals {
  global_variables = yamldecode(file("../../../global_variables.yaml"))
  resource_prefix  = "${var.org_name}-${var.stack_name}-${terraform.workspace}"
}

# ----------------------------------------------------------------------------------------------------------------------
# Terraform backend
# ----------------------------------------------------------------------------------------------------------------------

module "terraform_backend" {
  source    = "../../../modules/central_terraform_state"
  providers = { aws.backup = aws.backup }

  aws_backup_region = var.aws_backup_region
  bucket_name       = local.global_variables["terraform_state"]["bucket_name"]
  environment_name  = terraform.workspace
  resource_prefix   = local.resource_prefix
  spoke_accounts    = {}
}

# ----------------------------------------------------------------------------------------------------------------------
# AWS Logs bucket
# ----------------------------------------------------------------------------------------------------------------------

module "aws_service_logs_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.1.1"

  # Main
  bucket = "${var.org_name}-aws-service-logs-${var.aws_account_id}-${var.aws_region}"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # Object Ownership
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  # Logging delivery permissions
  attach_elb_log_delivery_policy             = true
  attach_lb_log_delivery_policy              = true
  access_log_delivery_policy_source_accounts = [var.aws_account_id]

  versioning = { enabled = true }

  lifecycle_rule = [
    {
      id      = "BasicExpiration"
      enabled = true

      abort_incomplete_multipart_upload_days = 7

      expiration = {
        days                         = 365
        expired_object_delete_marker = false
      }

      noncurrent_version_expiration = {
        newer_noncurrent_versions = 1
        days                      = 3
      }
    }
  ]
}

resource "aws_s3_bucket_notification" "this" {
  bucket      = module.aws_service_logs_bucket.s3_bucket_id
  eventbridge = true
}
