output "cluster_arn" {
  description = "ARN of the newly created cluster"
  value       = module.aurora.cluster_arn
}

output "cluster_id" {
  description = "ID of the newly created cluster"
  value       = module.aurora.cluster_id
}

output "cluster_endpoint" {
  description = "Main endpoint of the newly created cluster"
  value       = module.aurora.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint of the newly created cluster"
  value       = module.aurora.cluster_reader_endpoint
}

output "managed_client_policy_arn" {
  description = "Managed IAM policy, which allows clients to retrieve credentials for the database"
  value       = aws_iam_policy.client_permissions.arn
}

output "cluster_port" {
  description = "SQL port of database cluster"
  value       = module.aurora.cluster_port
}

output "cluster_master_user_secret_arn" {
  description = "ARN of AWS Secrets Manager secret which hosts database master password"
  value       = aws_secretsmanager_secret.this.arn
}

output "cluster_master_username" {
  description = "Master username of database cluster"
  value       = module.aurora.cluster_master_username
}