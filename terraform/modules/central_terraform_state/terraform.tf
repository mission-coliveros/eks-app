terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      configuration_aliases = [aws.backup]
      source                = "hashicorp/aws"
    }
  }

}
