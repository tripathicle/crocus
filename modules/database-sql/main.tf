ephemeral "random_password" "sql" {
  length  = 32
  special = true
}

resource "azurerm_mssql_server" "this" {
  name                                    = var.server_name
  location                                = var.location
  resource_group_name                     = var.resource_group_name
  version                                 = "12.0"
  administrator_login                     = var.administrator_login
  administrator_login_password_wo         = ephemeral.random_password.sql.result
  administrator_login_password_wo_version = 1
  public_network_access_enabled           = false
  minimum_tls_version                     = "1.2"
  tags                                    = var.tags


  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_mssql_database" "this" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.this.id
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  tags           = var.tags
}

resource "azurerm_mssql_server" "secondary" {
  count                                   = local.has_failover ? 1 : 0
  name                                    = "${var.server_name}-secondary"
  location                                = var.secondary_location
  resource_group_name                     = var.resource_group_name
  version                                 = "12.0"
  administrator_login                     = var.administrator_login
  administrator_login_password_wo         = ephemeral.random_password.sql.result
  administrator_login_password_wo_version = 1
  public_network_access_enabled           = false
  minimum_tls_version                     = "1.2"
  tags                                    = var.tags
}

resource "azurerm_mssql_failover_group" "this" {
  count     = local.has_failover ? 1 : 0
  name      = var.failover_group_name
  server_id = azurerm_mssql_server.this.id
  databases = [azurerm_mssql_database.this.id]

  partner_server {
    id = azurerm_mssql_server.secondary[0].id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}
