output "rg_name" { value = module.rg.name }
output "frontdoor_endpoint" { value = module.frontdoor.endpoint_host_name }
output "sql_server_fqdn" { value = module.sqldb.server_fqdn }
