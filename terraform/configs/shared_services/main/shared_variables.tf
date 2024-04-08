locals {
  shared_variables = {
    aws_accounts = {
      product = {
        prod = {
          aws_account_id = "361464906264"
          active_regions = ["us-west-2"]
        }
      }
    }

    networks = {
      cidrs = {
        aws = {
          shared_services = {}
          security        = {}

          product = {
            main = {
              prod = {
                vpc              = "10.100.0.0/16"
                private_subnets  = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
                cache_subnets    = ["10.100.101.0/24", "10.100.102.0/24", "10.100.103.0/24"]
                database_subnets = ["10.100.121.0/24", "10.100.122.0/24", "10.100.123.0/24"]
                public_subnets   = ["10.100.141.0/24", "10.100.142.0/24", "10.100.143.0/24"]
              }
            }
          }
        }
      }
    }

    s3 = {
      central_buckets = {
        aws_service_logs = module.aws_service_logs_bucket.s3_bucket_id
        terraform_state  = local.global_variables["terraform_state"]["bucket_name"]
      }
    }

    kms = {
      key_administrator_roles              = ["AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"]
      key_owner_roles                      = ["AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"]
      key_symmetric_encryption_user_roles  = ["AWSReservedSSO_AWSAdministratorAccess_cc835d33c7ce4750"]
      key_administrator_groups             = []
      key_owner_groups                     = []
      key_symmetric_encryption_user_groups = []
    }

    contacts = {
      admin_email             = "coliveros@missioncloud.com"
      cloudwatch_alarms_email = "coliveros@missioncloud.com"
    }

  }
}