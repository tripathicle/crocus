output "id" { value = azurerm_firewall.this.id }
output "name" { value = azurerm_firewall.this.name }
output "private_ip_address" { value = azurerm_firewall.this.ip_configuration[0].private_ip_address }
output "public_ip_id" { value = azurerm_public_ip.fw.id }
output "policy_id" { value = azurerm_firewall_policy.this.id }
