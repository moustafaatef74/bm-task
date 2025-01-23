variable "location" {
  type        = string
  description = "The region to deploy the resoruces in"
  default     = "uksouth"
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

variable "environment" {
  type        = string
  description = "The environment to deploy the resoruces in"
}

variable "registry_name" {
  type        = string
  description = "The name of the container registry"
}

variable "sku" {
  type        = string
  description = "The SKU of the container registry"
  default     = "Basic"
}