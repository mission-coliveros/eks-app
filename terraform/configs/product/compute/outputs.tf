output "cluster_arn" {
  value = module.eks_cluster.cluster_arn
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks_cluster.cluster_certificate_authority_data
}
