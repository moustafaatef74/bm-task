
variable "location" {
  type        = string
  description = "The region to deploy the resoruces in"
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "vnet_config" {
  description = "The configuration of the Application Gateway"
  type        = any
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

variable "environment_prefix" {
  type        = string
  description = "The environment to deploy the resoruces in"
}
