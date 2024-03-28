variable "resource_prefix" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "secrets_manager_kms_key_arn" {
  type = string
}