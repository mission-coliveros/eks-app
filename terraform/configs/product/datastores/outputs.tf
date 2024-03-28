# ----------------------------------------------------------------------------------------------------------------------
# Postgres cluster
# ----------------------------------------------------------------------------------------------------------------------

output "database_psql_cluster_arn" {
  description = "ID of the OpenZFS filesystem"
  value       = module.psql_database.cluster_arn
}

output "database_psql_cluster_id" {
  description = "DNS name of the OpenZFS filesystem"
  value       = module.psql_database.cluster_id
}

output "database_psql_cluster_endpoint" {
  description = "DNS name of the OpenZFS filesystem"
  value       = module.psql_database.cluster_endpoint
}

output "database_psql_cluster_reader_endpoint" {
  description = "DNS name of the OpenZFS filesystem"
  value       = module.psql_database.cluster_reader_endpoint
}

# ----------------------------------------------------------------------------------------------------------------------
# OpenZFS filesystem
# ----------------------------------------------------------------------------------------------------------------------

output "openzfs_file_system_id" {
  description = "ID of the OpenZFS filesystem"
  value       = module.openzfs_filesystem.filesystem_id
}

output "openzfs_file_system_dns_name" {
  description = "DNS name of the OpenZFS filesystem"
  value       = module.openzfs_filesystem.filesystem_dns_name
}

output "fsx_volume_ids" {
  description = "IDs of all created FSx volumes"
  value       = module.openzfs_filesystem.volume_ids
}

# ----------------------------------------------------------------------------------------------------------------------
# Elasticache
# ----------------------------------------------------------------------------------------------------------------------

output "elasticache_cluster_arn" {
  description = ""
  value       = module.elasticache_redis.elasticache_cluster_arn
}

output "elasticache_cluster_endpoint" {
  description = ""
  value       = module.elasticache_redis.elasticache_cluster_endpoint
}

# ----------------------------------------------------------------------------------------------------------------------
# ActiveMQ
# ----------------------------------------------------------------------------------------------------------------------

output "activemq_broker_arn" {
  description = ""
  value       = module.activemq.broker_arn
}

output "activemq_broker_id" {
  description = ""
  value       = module.activemq.broker_id
}

output "activemq_broker_endpoints" {
  description = ""
  value       = module.activemq.broker_endpoints
}