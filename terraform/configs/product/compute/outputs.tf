output "cluster_arn" {
  description = "ARN of the created cluster"
  value       = module.eks_cluster.cluster_arn
}

output "cluster_name" {
  description = "Name of the created cluster"
  value       = module.eks_cluster.cluster_name
}

output "cluster_oidc_provider_arn" {
  description = "OIDC provider ARN of the created cluster"
  value       = module.eks_cluster.oidc_provider_arn
}

output "cluster_endpoint" {
  description = "API endpoint of the created cluster"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "CA authority data of the created cluster"
  value       = module.eks_cluster.cluster_certificate_authority_data
}
