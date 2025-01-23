#------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------
locals {

  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  tags = merge(var.tags, {
    m-envrionment = var.environment
  })
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

#------------------------------------------------------------------------------
# Azure Container Registry
#------------------------------------------------------------------------------

resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = var.sku
  admin_enabled       = false
}