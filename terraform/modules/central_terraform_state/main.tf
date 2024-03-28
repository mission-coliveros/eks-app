# ----------------------------------------------------------------------------------------------------------------------
# Central Terraform State
# ----------------------------------------------------------------------------------------------------------------------

module "main_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.1.1"

  # Main
  bucket                  = var.bucket_name
  policy                  = data.aws_iam_policy_document.bucket_policy.json
  attach_policy           = true
  restrict_public_buckets = true
  versioning              = { enabled = true }

  # Lifecycle
  lifecycle_rule = [
    {
      id     = "NonCurrentVersionExpiration"
      status = "Enabled"
      noncurrent_version_expiration = {
        noncurrent_days           = 3
        newer_noncurrent_versions = 1
      }
    },
    {
      id                                     = "MultipartUploadAbortExpiration"
      status                                 = "Enabled"
      abort_incomplete_multipart_upload_days = 7
    }
  ]

  replication_configuration = {
    role = aws_iam_role.backup_replication.arn
    rules = [
      {
        id                        = "all"
        status                    = "Enabled"
        delete_marker_replication = true
        destination = {
          bucket        = local.calculated_bucket_arns.backup
          storage_class = "STANDARD"
        }
      }
    ]
  }
}

module "backup_bucket" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "~> 4.1.1"
  providers = { aws = aws.backup }

  # Main
  bucket                  = "${var.bucket_name}-backup"
  policy                  = data.aws_iam_policy_document.bucket_policy.json
  restrict_public_buckets = true
  versioning              = { enabled = true }

  # Lifecycle
  lifecycle_rule = [
    {
      id     = "NonCurrentVersionExpiration"
      status = "Enabled"
      noncurrent_version_expiration = {
        noncurrent_days           = 3
        newer_noncurrent_versions = 1
      }
    },
    {
      id                                     = "MultipartUploadAbortExpiration"
      status                                 = "Enabled"
      abort_incomplete_multipart_upload_days = 7
    }
  ]

}

resource "aws_iam_role" "backup_replication" {
  assume_role_policy = data.aws_iam_policy_document.terraform_state_backup_assume_role.json
}

data "aws_iam_policy_document" "terraform_state_backup_assume_role" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "backup_replication" {
  role   = aws_iam_role.backup_replication.id
  policy = data.aws_iam_policy_document.backup_replication_permissions.json
}

data "aws_iam_policy_document" "backup_replication_permissions" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
    resources = [local.calculated_bucket_arns.main]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObjectVersion", "s3:GetObjectVersionAcl"]
    resources = [local.calculated_bucket_arns.main]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:ReplicateObject", "s3:ReplicateDelete"]
    resources = ["${local.calculated_bucket_arns.backup}/*"]
  }
}

data "aws_iam_policy_document" "bucket_policy" {

  statement {
    actions   = ["s3:ListBucket"]
    resources = [local.calculated_bucket_arns.main]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${local.calculated_bucket_arns.main}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }

  dynamic "statement" {
    for_each = var.spoke_accounts
    content {
      sid       = "${replace(statement.key, "_", "-")}-list"
      actions   = ["s3:ListBucket"]
      resources = [local.calculated_bucket_arns.main]

      condition {
        test     = "StringLike"
        variable = "s3:prefix"
        values   = ["${replace(statement.key, "_", "-")}/*"]
      }

      principals {
        type        = "AWS"
        identifiers = [statement.value["aws_account_id"]]
      }

    }
  }

  dynamic "statement" {
    for_each = var.spoke_accounts
    content {
      sid       = "${replace(statement.key, "_", "-")}-rw"
      actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
      resources = ["${local.calculated_bucket_arns.main}/${replace(statement.key, "_", "-")}/*"]

      principals {
        type        = "AWS"
        identifiers = [statement.value["aws_account_id"]]
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
