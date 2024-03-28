# Terraform Module: Centralized Terraform State

## Overview
TBD

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup_bucket"></a> [backup\_bucket](#module\_backup\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.10.1 |
| <a name="module_main_bucket"></a> [main\_bucket](#module\_main\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.10.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.backup_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.backup_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.backup_replication_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.terraform_state_backup_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_backup_region"></a> [aws\_backup\_region](#input\_aws\_backup\_region) | AWS region to deploy backup TF state bucket to | `string` | `"us-east-2"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of Terraform state bucket | `string` | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Name of logical environment | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to assign to all created resources | `string` | n/a | yes |
| <a name="input_spoke_accounts"></a> [spoke\_accounts](#input\_spoke\_accounts) | List of spoke accounts and their IDs to grant path-based permissions to | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_bucket"></a> [backup\_bucket](#output\_backup\_bucket) | Terraform backup state bucket information |
| <a name="output_main_bucket"></a> [main\_bucket](#output\_main\_bucket) | Terraform state bucket information |
| <a name="output_s"></a> [s](#output\_s) | n/a |
<!-- END_TF_DOCS -->