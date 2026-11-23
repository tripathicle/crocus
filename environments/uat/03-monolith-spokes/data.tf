data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "hub" {
  name = "rg-hub-${var.environment}"
}

data "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.environment}"
  resource_group_name = data.azurerm_resource_group.hub.name
}
