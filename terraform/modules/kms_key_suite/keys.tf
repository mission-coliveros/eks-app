locals {
  kms_key_specs = {

    # ------------------------------------------------------------------------------------------------------------------
    # CloudTrail
    # ------------------------------------------------------------------------------------------------------------------

    cloudtrail = {
      key_statements = [
        {
          sid    = "Allow CloudTrail to encrypt logs"
          effect = "Allow"
          principals = [
            {
              type        = "Service"
              identifiers = ["cloudtrail.amazonaws.com"]
            }
          ]
          actions   = ["kms:GenerateDataKey"]
          resources = ["*"]
          conditions = [
            {
              test     = "ArnEquals"
              variable = "aws:SourceArn"
              values   = ["arn:aws:cloudtrail:${local.aws_region}:${local.aws_account_id}:trail/*"]
            },
            {
              test     = "StringLike"
              variable = "kms:EncryptionContext:aws:cloudtrail:arn"
              values   = ["arn:aws:cloudtrail:${local.aws_region}:${local.aws_account_id}:trail/*"]
            }
          ]
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------
    # EBS
    # ------------------------------------------------------------------------------------------------------------------

    ebs = {
      allowed_services                  = []
      key_service_roles_for_autoscaling = [var.autoscaling_service_role_arn]
    }

    # ------------------------------------------------------------------------------------------------------------------
    # EFS
    # ------------------------------------------------------------------------------------------------------------------

    efs = {
      allowed_services = ["elasticfilesystem"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # Elasticache
    # ------------------------------------------------------------------------------------------------------------------

    elasticache = {
      allowed_services = ["elasticache"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # Glue
    # ------------------------------------------------------------------------------------------------------------------

    glue = {
      allowed_services = ["glue"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # CloudWatch Logs
    # ------------------------------------------------------------------------------------------------------------------

    logs = {
      key_statements = [
        {
          effect = "Allow"
          principals = [
            { type        = "Service"
              identifiers = ["logs.${local.aws_region}.amazonaws.com"]
            }
          ]
          actions = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ]
          resources = ["*"]
          conditions = [
            {
              test     = "ArnLike"
              variable = "kms:EncryptionContext:aws:logs:arn"
              values   = ["arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group:*"]
            }
          ]
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------
    # RDS
    # ------------------------------------------------------------------------------------------------------------------

    rds = {
      allowed_services = ["rds"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # S3
    # ------------------------------------------------------------------------------------------------------------------

    s3 = {
      allowed_services = ["s3"]
      key_statements = [
        {
          sid    = "AWSConfigKMSPolicy"
          effect = "Allow"
          principals = [
            {
              type        = "AWS"
              identifiers = [local.aws_account_id]
            }
          ]
          actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
          resources = ["*"]
        }
      ]
    }

    # ------------------------------------------------------------------------------------------------------------------
    # Systems Manager
    # ------------------------------------------------------------------------------------------------------------------

    systems-manager = {
      allowed_services = ["ssm"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # Secrets Manager
    # ------------------------------------------------------------------------------------------------------------------

    secrets-manager = {
      allowed_services = ["secrets-manager"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # SNS
    # ------------------------------------------------------------------------------------------------------------------

    sns = {
      allowed_services = [
        "cloudwatch",
        "events",
        "dms",
        "ds",
        "dynamodb",
        "inspector",
        "redshift",
        "events.rds",
        "glacier",
        "ses",
        "s3",
        "importexport",
        "sns",
        "ssm-incidents",
        "ssm-contacts"
      ]
      key_statements = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # SES
    # ------------------------------------------------------------------------------------------------------------------

    ses = {
      allowed_services = ["ses"]
      key_statements   = []
    }

    # ------------------------------------------------------------------------------------------------------------------
    # SQS
    # ------------------------------------------------------------------------------------------------------------------

    sqs = {
      allowed_services = ["sqs"]
      key_statements   = []
    }

  }
}

module "merged_kms_key_specs" {
  source  = "cloudposse/config/yaml//modules/deepmerge"
  version = "~> 1.0.2"

  maps = [local.kms_key_specs, var.kms_key_overrides]
}
