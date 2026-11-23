output "server_id" { value = azurerm_mssql_server.this.id }
output "server_name" { value = azurerm_mssql_server.this.name }
output "server_fqdn" { value = azurerm_mssql_server.this.fully_qualified_domain_name }
output "database_id" { value = azurerm_mssql_database.this.id }
output "database_name" { value = azurerm_mssql_database.this.name }
output "failover_group_id" { value = try(azurerm_mssql_failover_group.this[0].id, null) }
