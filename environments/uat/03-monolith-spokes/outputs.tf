output "spoke_rg_names" { value = { for k, v in module.spoke_rg : k => v.name } }
output "spoke_vnet_ids" { value = { for k, v in module.spoke_network : k => v.vnet_id } }
output "spoke_app_ids" { value = { for k, v in module.spoke_app : k => v.app_ids } }
