variable "location" {
  type        = string
  description = "The region to deploy the resoruces in"
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
  default     = "common-tooling"
}

variable "tags" {
  description = "additional tags for the vnet"
  type        = map(string)
  default     = {}
}