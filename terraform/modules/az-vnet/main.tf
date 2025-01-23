#------------------------------------------------------------------------------
# Local Variables
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Important Note:
# Some services in Azure requires dedicated subnets, for example, Application Gateway requires a dedicated subnet.
# Read more here for the list of services that requires dedicated subnets: 
# https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-for-azure-services#services-that-can-be-deployed-into-a-virtual-network
#------------------------------------------------------------------------------
locals {

  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  cidr = "10.${var.vnet_config.cidr_b_block}.0.0/16"

  newbits = [for s in var.vnet_config.subnets : s.newbits]

  subnets = cidrsubnets(local.cidr, local.newbits...)

  subnet_names    = [for subnet in var.vnet_config.subnets : "${var.environment_prefix}-${subnet.name}"]
  private_subnets = [for subnet in var.vnet_config.subnets : "${var.environment_prefix}-${subnet.name}" if subnet.is_public == false]

  tags = merge(var.tags, {
    m-envrionment = var.environment,
  })
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

#------------------------------------------------------------------------------
# Private Route Table
#------------------------------------------------------------------------------

resource "azurerm_route_table" "vnet_private_routing_table" {
  name                = "${var.environment_prefix}-private-routing-table"
  location            = var.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_route" "vnet_private_routing_table_default_route" {
  resource_group_name = local.resource_group_name
  route_table_name    = azurerm_route_table.vnet_private_routing_table.name

  name           = "${var.environment_prefix}-internal-vnet-routing"
  address_prefix = local.cidr
  next_hop_type  = "VnetLocal"
}

#------------------------------------------------------------------------------
# Public Route Table
#------------------------------------------------------------------------------

resource "azurerm_route_table" "vnet_public_routing_table" {
  name                = "${var.environment_prefix}-public-routing-table"
  location            = var.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_route" "vnet_public_routing_table_default_route" {
  resource_group_name = local.resource_group_name
  route_table_name    = azurerm_route_table.vnet_public_routing_table.name

  name           = "${var.environment_prefix}-internal-vnet-routing"
  address_prefix = local.cidr
  next_hop_type  = "VnetLocal"
}

resource "azurerm_route" "vnet_public_routing_table_internet_route" {
  resource_group_name = local.resource_group_name
  route_table_name    = azurerm_route_table.vnet_public_routing_table.name

  name           = "${var.environment_prefix}-Internet-routing"
  address_prefix = "0.0.0.0/0"
  next_hop_type  = "Internet"
}

#------------------------------------------------------------------------------
# VNet
#------------------------------------------------------------------------------

module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.0.0"
  vnet_name           = "${var.environment_prefix}-vnet"
  resource_group_name = local.resource_group_name
  use_for_each        = true
  address_space       = [local.cidr]
  subnet_prefixes     = local.subnets

  route_tables_ids = merge(
    {
      for subnet in var.vnet_config.subnets :
      "${var.environment_prefix}-${subnet.name}" => subnet.is_public ? azurerm_route_table.vnet_public_routing_table.id : azurerm_route_table.vnet_private_routing_table.id
    }
  )

  subnet_names = local.subnet_names

  subnet_service_endpoints = merge(
    {
      for subnet in var.vnet_config.subnets :
      "${var.environment_prefix}-${subnet.name}" => subnet.subnet_service_endpoints if length(try(subnet.subnet_service_endpoints, [])) > 0
    }
  )

  subnet_delegation = {
    for subnet in var.vnet_config.subnets :
    "${var.environment_prefix}-${subnet.name}" => {
      try(subnet.subnet_delegation.action, {}) = {
        service_name    = try(subnet.subnet_delegation.service_name, null)
        service_actions = try(subnet.subnet_delegation.service_actions, null)
      }
    } if can(subnet.subnet_delegation)
  }

  vnet_location = var.location
  tags          = local.tags
}

#------------------------------------------------------------------------------
# Nat Gateway
#------------------------------------------------------------------------------

resource "azurerm_public_ip" "nat_ip" {

  count = var.vnet_config.nat_gateway.enabled == true ? 1 : 0

  name                = "${var.environment_prefix}-nat-gateway-public-ip"
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.vnet_config.nat_gateway.zones

  tags = local.tags
}

resource "azurerm_nat_gateway" "nat_gateway" {
  count = var.vnet_config.nat_gateway.enabled == true ? 1 : 0

  name                    = "${var.environment_prefix}-nat-gateway"
  location                = var.location
  resource_group_name     = local.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = var.vnet_config.nat_gateway.zones

  tags = local.tags
}

resource "azurerm_nat_gateway_public_ip_association" "net_ip_association" {
  count = var.vnet_config.nat_gateway.enabled == true ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.nat_ip[0].id
}


resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  for_each = var.vnet_config.nat_gateway.enabled == true ? toset(local.private_subnets) : toset([])

  subnet_id      = lookup(module.vnet.vnet_subnets_name_id, each.key)
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
}