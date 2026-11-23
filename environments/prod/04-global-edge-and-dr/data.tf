data "azurerm_client_config" "current" {}

data "azurerm_subnet" "appgw" {
  name                 = "snet-appgw"
  virtual_network_name = "vnet-hub-${var.environment}"
  resource_group_name  = "rg-hub-${var.environment}"
}
