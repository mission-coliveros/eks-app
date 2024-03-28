output "main_bucket" {
  description = "Terraform state bucket information"
  value       = module.main_bucket
}

output "backup_bucket" {
  description = "Terraform backup state bucket information"
  value       = module.backup_bucket
}

output "dynamodb_lock_table_id" {
  description = ""
  value       = aws_dynamodb_table.terraform_lock.id
}

output "dynamodb_lock_table_arn" {
  description = ""
  value       = aws_dynamodb_table.terraform_lock.arn
}

output "dynamodb_lock_table_name" {
  description = ""
  value       = aws_dynamodb_table.terraform_lock.name
}