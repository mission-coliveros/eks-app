resource "aws_ecr_repository" "app" {
  name = "${local.resource_prefix}-app"
}

resource "aws_ecr_repository" "helm" {
  name = "${local.resource_prefix}-helm"
}
