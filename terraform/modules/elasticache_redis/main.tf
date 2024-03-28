locals {
  # if !cluster, then node_count = replica cluster_size, if cluster then node_count = shard*(replica + 1)
  # Why doing this 'The "count" value depends on resource attributes that cannot be determined until apply'. So pre-calculating
  member_clusters_count = var.cluster_mode_enabled ? var.num_node_groups * (var.replicas_per_node_group + 1) : var.cluster_size
  # member_clusters       = tolist(aws_elasticache_replication_group.this.member_clusters)
  auth_token            = coalesce(one(data.aws_secretsmanager_secret_version.auth_token[*].secret_string), one(random_password.auth_token[*].result))
}

resource "random_password" "auth_token" {
  count = var.auth_token_secret_id == null ? 1 : 0

  length           = 32
  special          = true
  override_special = "!&#$^<>-"
  min_lower        = 1
  min_numeric      = 1
  min_upper        = 1
  min_special      = 1
}

resource "aws_ssm_parameter" "auth_token" {
  count = var.auth_token_secret_id == null ? 1 : 0

  name  = "${var.resource_prefix}-auth-token"
  type  = "SecureString"
  value = one(random_password.auth_token[*].result)
  tags  = var.tags
}

data "aws_secretsmanager_secret_version" "auth_token" {
  count = var.auth_token_secret_id == null ? 0 : 1

  secret_id = var.auth_token_secret_id
}

resource "aws_elasticache_serverless_cache" "this" {
  name = var.resource_prefix

  engine               = "redis"
  major_engine_version = "7"

  security_group_ids = var.cluster_security_group_ids
  subnet_ids         = var.subnet_ids

  description = var.resource_prefix
  kms_key_id  = var.kms_key_id

  snapshot_retention_limit = 7
  daily_snapshot_time      = "09:00"

  cache_usage_limits {

    data_storage {
      maximum = 10
      unit    = "GB"
    }

    ecpu_per_second {
      maximum = 1000
    }
  }
}

#resource "aws_elasticache_replication_group" "this" {
#  apply_immediately           = var.apply_immediately
#  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
#  auth_token                  = var.transit_encryption_enabled ? local.auth_token : null
#  auto_minor_version_upgrade  = true
#  automatic_failover_enabled  = var.cluster_mode_enabled ? true : var.automatic_failover_enabled
#  data_tiering_enabled        = var.data_tiering_enabled
#  description                 = var.description
#  engine_version              = var.engine_version
#  kms_key_id                  = var.at_rest_encryption_enabled ? var.kms_key_id : null
#  maintenance_window          = var.maintenance_window
#  multi_az_enabled            = var.cluster_mode_enabled ? true : var.multi_az_enabled
#  node_type                   = var.node_type
#  num_cache_clusters          = var.cluster_mode_enabled ? null : var.cluster_size
#  num_node_groups             = var.cluster_mode_enabled ? var.num_node_groups : null
#  notification_topic_arn      = var.notification_topic_arn
#  parameter_group_name        = aws_elasticache_parameter_group.this.id
#  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
#  port                        = var.port
#  replication_group_id        = var.resource_prefix
#  replicas_per_node_group     = var.replicas_per_node_group
#  security_group_ids          = [var.cluster_security_group_ids]
#  snapshot_arns               = var.snapshot_arns
#  snapshot_name               = var.snapshot_name
#  snapshot_retention_limit    = var.snapshot_retention_limit
#  snapshot_window             = var.snapshot_window
#  subnet_group_name           = aws_elasticache_subnet_group.this.id
#  tags                        = var.tags
#  transit_encryption_enabled  = var.transit_encryption_enabled || local.auth_token != null
#  user_group_ids              = var.user_group_ids
#
#  log_delivery_configuration {
#    destination      = aws_cloudwatch_log_group.this.id
#    destination_type = "cloudwatch-logs"
#    log_format       = "json"
#    log_type         = "slow-log"
#  }
#  log_delivery_configuration {
#    destination      = aws_cloudwatch_log_group.this.id
#    destination_type = "cloudwatch-logs"
#    log_format       = "json"
#    log_type         = "engine-log"
#  }
#  replication_group_description = ""
#}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/elasticache/${var.resource_prefix}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloud_watch_log_kms_key
  tags              = var.tags
}

#resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
#  count               = var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
#  alarm_name          = "${element(local.member_clusters, count.index)}-cpu-utilization"
#  alarm_description   = "Redis cluster CPU utilization"
#  comparison_operator = "GreaterThanThreshold"
#  evaluation_periods  = "1"
#  metric_name         = "CPUUtilization"
#  namespace           = "AWS/ElastiCache"
#  period              = "300"
#  statistic           = "Average"
#
#  threshold = var.alarm_cpu_threshold_percent
#
#  dimensions = {
#    CacheClusterId = element(local.member_clusters, count.index)
#  }
#
#  alarm_actions = var.alarm_actions
#  ok_actions    = var.ok_actions
#  depends_on    = [aws_elasticache_replication_group.this]
#
#  tags = var.tags
#}
#
#resource "aws_cloudwatch_metric_alarm" "cache_memory" {
#  count               = var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
#  alarm_name          = "${element(local.member_clusters, count.index)}-freeable-memory"
#  alarm_description   = "Redis cluster freeable memory"
#  comparison_operator = "LessThanThreshold"
#  evaluation_periods  = "1"
#  metric_name         = "FreeableMemory"
#  namespace           = "AWS/ElastiCache"
#  period              = "60"
#  statistic           = "Average"
#
#  threshold = var.alarm_memory_threshold_bytes
#
#  dimensions = {
#    CacheClusterId = element(local.member_clusters, count.index)
#  }
#
#  alarm_actions = var.alarm_actions
#  ok_actions    = var.ok_actions
#  depends_on    = [aws_elasticache_replication_group.this]
#
#  tags = var.tags
#}

resource "aws_elasticache_parameter_group" "this" {
  name        = var.resource_prefix
  description = "ElastiCache for Redis parameter group ${var.resource_prefix}"

  # Strip the patch version from redis_version var
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([
      { name = "cluster-enabled", value = "yes" }
    ], var.parameters) : var.parameters
    content {
      name  = parameter.value["name"]
      value = tostring(parameter.value["value"])
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
