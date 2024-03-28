data "aws_rds_engine_version" "this" {
  version      = var.cluster_engine_version
  engine       = var.cluster_engine
  default_only = true

  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }
}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.3.1"

  name                    = var.cluster_name
  cluster_use_name_prefix = false

  # Engine
  engine                      = data.aws_rds_engine_version.this.engine
  engine_mode                 = "provisioned"
  engine_version              = try(var.cluster_engine_full_version, data.aws_rds_engine_version.this.version)
  allow_major_version_upgrade = true
  enable_http_endpoint        = false

  # Authentication
  master_username                     = var.cluster_master_username
  manage_master_user_password         = false # Parallelcluster doesn't support the the use of managed passwords, as the value is JSON encoded
  master_password                     = aws_secretsmanager_secret_version.this.secret_string
  iam_database_authentication_enabled = false
  ca_cert_identifier                  = "rds-ca-rsa2048-g1"

  # Maintenance
  apply_immediately            = var.cluster_apply_immediately
  preferred_maintenance_window = var.cluster_preferred_maintenance_window

  # Backup
  backup_retention_period = 7
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = true
  deletion_protection     = true
  snapshot_identifier     = var.cluster_snapshot_identifier
  preferred_backup_window = var.cluster_preferred_backup_window

  # Instances
  instances = module.merged_cluster_instances.merged
  serverlessv2_scaling_configuration = {
    min_capacity = var.cluster_min_capacity
    max_capacity = var.cluster_max_capacity
  }

  # Storage
  storage_encrypted = true

  # Encryption
  # kms_key_id                      = var.cluster_kms_key_id
  # master_user_secret_kms_key_id   = var.secrets_manager_kms_key_arn
  performance_insights_kms_key_id = var.performance_insights_kms_key_arn

  # Network
  vpc_id       = var.cluster_vpc_id
  network_type = "IPV4"
  port         = 3306

  # Subnets
  db_subnet_group_name   = var.cluster_name
  create_db_subnet_group = true
  subnets                = var.cluster_subnets

  # Security groups
  create_security_group  = false
  vpc_security_group_ids = var.cluster_security_group_ids

  # Cluster parameter group
  create_db_cluster_parameter_group          = true
  db_cluster_parameter_group_name            = var.cluster_name
  db_cluster_parameter_group_description     = "Cluster parameter group for aurora-mysql"
  db_cluster_parameter_group_use_name_prefix = false
  db_cluster_parameter_group_family          = var.cluster_parameter_group_family
  db_cluster_parameter_group_parameters = [for k, v in module.merged_db_cluster_parameter_group_parameters.merged : {
    name         = k
    value        = lookup(v, "value", null)
    apply_method = lookup(v, "apply_method", null)
  }]

  # Database parameter group
  create_db_parameter_group          = true
  db_parameter_group_name            = var.cluster_name
  db_parameter_group_family          = var.cluster_db_parameter_group_family
  db_parameter_group_use_name_prefix = false
  db_parameter_group_parameters = [for k, v in module.merged_db_parameter_group_parameters.merged : {
    name         = k
    value        = lookup(v, "value", null)
    apply_method = lookup(v, "apply_method", null)
  }]

  # Observability
  create_cloudwatch_log_group            = true
  enabled_cloudwatch_logs_exports        = var.cluster_enabled_cloudwatch_logs_exports
  cloudwatch_log_group_kms_key_id        = var.performance_insights_kms_key_arn
  cloudwatch_log_group_retention_in_days = 365
  performance_insights_enabled           = var.cluster_performance_insights_enabled
  performance_insights_retention_period  = 7

  tags = local.tags
}
