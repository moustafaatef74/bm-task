variable "location" {
  type        = string
  description = "The region to deploy the resoruces in"
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "resource group name"
  type        = string
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

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "The subnet id to deploy the AKS in"
}

variable "node_pools" {
  type = map(object({
    name                 = string
    vm_size              = string
    vnet_subnet_id       = string
    node_count           = number
    min_count            = number
    max_count            = number
    enable_auto_scaling  = bool
    orchestrator_version = string
    tags                 = optional(map(string))
  }))

  description = "The node pools to deploy in the AKS cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "The kubernetes version to deploy"
  default     = "1.26.6"
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "The object ids of the admin groups"
  default     = []
}

variable "container_registry" {
  type        = string
  description = "The name of the container registry"
}

variable "acr_resource_group_name" {
  type        = string
  description = "The resource group name of the container registry"
}