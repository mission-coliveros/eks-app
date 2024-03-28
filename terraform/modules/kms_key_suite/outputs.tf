output "key_ids" {
  description = "Map of KMS key IDs. Default keys: [cloudtrail, ebs, efs, elasticache, glue, logs, rds, s3, systems-manager, secrets-manager, sns, ses, sqs]"
  value       = zipmap(keys(module.kms), [for k, v in module.kms : v.key_id])
}

output "key_arns" {
  description = "Map of KMS key ARNs. Default keys: [cloudtrail, ebs, efs, elasticache, glue, logs, rds, s3, systems-manager, secrets-manager, sns, ses, sqs]"
  value       = zipmap(keys(module.kms), [for k, v in module.kms : v.key_arn])
}

output "key_aliases" {
  description = "Map of KMS key Aliases. Default keys: [cloudtrail, ebs, efs, elasticache, glue, logs, rds, s3, systems-manager, secrets-manager, sns, ses, sqs]"
  value       = zipmap(keys(module.kms), [for k, v in module.kms : v.aliases])
}
