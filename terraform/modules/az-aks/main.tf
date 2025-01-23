#------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------

locals {
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  tags = merge(var.tags, {
    m-envrionment = var.environment,
  })
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_container_registry" "acr" {
  name                = var.container_registry
  resource_group_name = var.acr_resource_group_name
}

#------------------------------------------------------------------------------
# AKS module & related resources
#------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "main" {
  location            = local.location
  name                = "${var.environment}-uami-${var.cluster_name}"
  resource_group_name = local.resource_group_name
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "7.4.0"

  prefix              = "${var.environment}-${var.cluster_name}"
  cluster_name        = var.cluster_name
  resource_group_name = local.resource_group_name
  identity_ids        = [azurerm_user_assigned_identity.main.id]
  identity_type       = "UserAssigned"

  os_disk_size_gb               = 60
  public_network_access_enabled = false
  sku_tier                      = "Standard"

  log_analytics_workspace_enabled = false
  log_retention_in_days           = 0

  vnet_subnet_id = var.subnet_id

  orchestrator_version = var.kubernetes_version
  enable_auto_scaling  = true
  agents_min_count     = 1
  agents_max_count     = 5
  node_pools           = var.node_pools

  network_plugin = "azure"
  network_contributor_role_assigned_subnet_ids = {
    vnet_subnet = var.subnet_id
  }

  kubernetes_version = var.kubernetes_version

  workload_identity_enabled         = true
  oidc_issuer_enabled               = true
  role_based_access_control_enabled = true
  rbac_aad                          = true
  rbac_aad_managed                  = true
  rbac_aad_admin_group_object_ids   = var.admin_group_object_ids

  // Node pool settings
  node_resource_group = "${var.environment}-${var.cluster_name}-nodes-rg"

  attached_acr_id_map = {
    default = data.azurerm_container_registry.acr.id
  }
}