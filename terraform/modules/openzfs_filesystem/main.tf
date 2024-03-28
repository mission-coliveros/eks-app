resource "aws_fsx_openzfs_file_system" "this" {
  deployment_type = "SINGLE_AZ_2"

  # Network
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  # Storage/throughput
  storage_capacity                = var.filesystem_storage_capacity
  throughput_capacity             = 2560
  automatic_backup_retention_days = 60

  root_volume_configuration {
    data_compression_type = "NONE"

    nfs_exports {
      client_configurations {
        clients = "*"
        options = ["no_root_squash", "rw", "crossmnt"]
      }
    }

  }

  tags = merge({ Name = var.resource_prefix }, var.tags)

}

resource "aws_fsx_openzfs_volume" "this" {
  for_each         = { for k, v in var.filesystem_volumes : k => v if lookup(v, "create", true) }
  name             = each.key
  parent_volume_id = aws_fsx_openzfs_file_system.this.root_volume_id

  nfs_exports {
    client_configurations {
      clients = "*"
      options = ["rw", "crossmnt", "no_root_squash"]
    }
  }

  tags = var.tags
}
