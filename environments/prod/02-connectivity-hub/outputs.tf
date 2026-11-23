output "rg_name" { value = module.rg.name }
output "vnet_id" { value = module.network.vnet_id }
output "firewall_private_ip" { value = module.firewall.private_ip_address }
output "dns_zone_ids" { value = module.dns.zone_ids }
