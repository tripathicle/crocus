resource "azurerm_recovery_services_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.tags


  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_data_protection_backup_vault" "this" {
  name                = "${var.name}-dp"
  location            = var.location
  resource_group_name = var.resource_group_name
  datastore_type      = "VaultStore"
  redundancy          = "GeoRedundant"
  tags                = var.tags
}
