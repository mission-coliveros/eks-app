resource "random_password" "this" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "this" {
  name       = "${var.cluster_name}-client-password"
  kms_key_id = var.secrets_manager_kms_key_arn
}

resource "aws_secretsmanager_secret_version" "this" {
  lifecycle { ignore_changes = [secret_string] }

  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = random_password.this.result
}

resource "aws_iam_policy" "client_permissions" {
  name = "${var.cluster_name}-db-client-access"

  policy = data.aws_iam_policy_document.client_permissions.json
  tags   = local.tags
}

data "aws_iam_policy_document" "client_permissions" {
  statement {
    sid       = "AuthSecretRetrievalPermissions"
    effect    = "Allow"
    actions   = ["secretsmanager:DescribeSecret", "secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.this.arn]
  }

  statement {
    sid     = "KmsDecryptPermissions"
    effect  = "Allow"
    actions = ["kms:Decrypt"]
    resources = [
      aws_secretsmanager_secret.this.kms_key_id,
      var.cluster_kms_key_id
    ]
  }

}
