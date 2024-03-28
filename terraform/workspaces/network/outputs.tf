output "vpc_id" {
  description = "ID of created VPC"
  value       = module.vpc.vpc_id
}

output "availability_zones" {
  description = "Availability zones resources are deployed to"
  value       = var.availability_zones
}

output "vpc_cidr_block" {
  description = "CIDR block of VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_arn" {
  description = "ARN of created VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_subnet_ids" {
  description = "IDs of all created subnets"
  value = {
    private  = module.vpc.private_subnets
    public   = module.vpc.public_subnets
    cache    = module.vpc.elasticache_subnets
    database = module.vpc.database_subnets
    intra    = module.vpc.intra_subnets
    redshift = module.vpc.redshift_subnets
  }
}

output "vpc_subnet_arns" {
  description = "IDs of all created subnets"
  value = {
    private  = module.vpc.private_subnet_arns
    public   = module.vpc.public_subnet_arns
    cache    = module.vpc.elasticache_subnet_arns
    database = module.vpc.database_subnet_arns
    intra    = module.vpc.intra_subnet_arns
    redshift = module.vpc.redshift_subnet_arns
  }
}

output "vpc_cidrs" {
  description = "CIDRs of all created subnets"
  value = {
    private  = module.vpc.private_subnets_cidr_blocks
    public   = module.vpc.public_subnets_cidr_blocks
    cache    = module.vpc.elasticache_subnets_cidr_blocks
    database = module.vpc.database_subnets_cidr_blocks
    intra    = module.vpc.intra_subnets_cidr_blocks
    redshift = module.vpc.redshift_subnets_cidr_blocks
  }
}

output "security_group_ids" {
  description = "IDs of all created security groups"
  value       = zipmap(keys(local.merged_security_groups), [for security_group in aws_security_group.this : security_group.id])
}

output "security_group_arns" {
  description = "IDs of all created security groups"
  value       = zipmap(keys(local.merged_security_groups), [for security_group in aws_security_group.this : security_group.arn])
}
