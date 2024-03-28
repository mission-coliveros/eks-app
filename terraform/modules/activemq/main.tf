resource "aws_mq_broker" "this" {
  broker_name = "${var.resource_prefix}-activemq"

  configuration {
    id       = aws_mq_configuration.this.id
    revision = aws_mq_configuration.this.latest_revision
  }

  engine_type        = "ActiveMQ"
  engine_version     = "5.17.6"
  host_instance_type = "mq.t3.micro"
  security_groups    = var.security_groups
  subnet_ids         = var.subnet_ids

  user {
    username = jsondecode(aws_secretsmanager_secret_version.this.secret_string)["username"]
    password = jsondecode(aws_secretsmanager_secret_version.this.secret_string)["password"]
  }
}

resource "aws_mq_configuration" "this" {
  name           = "${var.resource_prefix}-activemq"
  engine_type    = "ActiveMQ"
  engine_version = "5.17.6"

  data = file("assets/activemq/config.xml")
}