ephemeral "random_password" "pg" {
  length  = 32
  special = true
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  version                           = var.postgres_version
  administrator_login               = var.administrator_login
  administrator_password_wo         = ephemeral.random_password.pg.result
  administrator_password_wo_version = 1
  storage_mb                        = var.storage_mb
  sku_name                          = var.sku_name
  zone                              = "1"
  high_availability {
    mode = local.mode
  }
  public_network_access_enabled = false
  tags                          = var.tags


  lifecycle {
    prevent_destroy = true
  }
}
