variable "filesystem_volumes" {
  description = ""
  type        = any
  default     = {}
}

variable "subnet_ids" {
  description = ""
  type        = list(string)
}

variable "security_group_ids" {
  description = ""
  type        = list(string)
}

variable "filesystem_storage_capacity" {
  description = ""
  type        = number
}

variable "resource_prefix" {
  description = ""
  type        = string
}

variable "tags" {
  description = ""
  type        = map(string)
  default     = {}
}
