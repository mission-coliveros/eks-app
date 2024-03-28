output "elasticache_cluster_endpoint" {
  value = aws_elasticache_serverless_cache.this.endpoint
}

output "elasticache_cluster_arn" {
  value = aws_elasticache_serverless_cache.this.arn
}