output "filesystem_id" {
  description = "ID of the OpenZFS filesystem"
  value       = aws_fsx_openzfs_file_system.this.id
}

output "filesystem_dns_name" {
  description = "DNS name of the OpenZFS filesystem"
  value       = aws_fsx_openzfs_file_system.this.dns_name
}

output "volume_ids" {
  description = "IDs of all created FSx volumes"
  value       = zipmap(keys(aws_fsx_openzfs_volume.this), [for volume in aws_fsx_openzfs_volume.this : volume.id])
}
