output "kms_key_ids" {
  description = "Map of the created security groups"
  value       = module.kms.key_ids
}

output "kms_key_arns" {
  description = "Map of the created security groups"
  value       = module.kms.key_arns
}

output "kms_key_aliases" {
  description = "Map of the created security groups"
  value       = module.kms.key_aliases
}
