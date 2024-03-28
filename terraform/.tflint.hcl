config {
  module = true
  force = false
  format = "compact"
}

plugin "terraform" {
  enabled = true
  preset  = "all"

}

plugin "aws" {
  enabled = true
  version = "0.24.1"
  source = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_type" {
  enabled = false
}
