output "broker_arn" {
  description = ""
  value       = aws_mq_broker.this.arn
}

output "broker_id" {
  description = ""
  value       = aws_mq_broker.this.id
}

output "broker_endpoints" {
  description = ""
  value       = aws_mq_broker.this.instances[0].endpoints
}
