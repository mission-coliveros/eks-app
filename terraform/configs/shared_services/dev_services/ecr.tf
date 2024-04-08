module "ecr" {
  for_each = toset(["app", "helm"])
  source   = "terraform-aws-modules/ecr/aws"
  version  = "~> 2.0.0"

  repository_name = "${local.resource_prefix}-${each.key}"

  repository_read_access_arns = [
    for k, v in local.shared_variables["aws_accounts"]["product"] :
    "arn:aws:iam::${v["aws_account_id"]}:root"
  ]
  repository_read_write_access_arns = concat(
    [data.aws_caller_identity.current.arn]
  )

  create_lifecycle_policy = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        action       = { type = "expire" }
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
      }
    ]
  })

  repository_force_delete = true
}
