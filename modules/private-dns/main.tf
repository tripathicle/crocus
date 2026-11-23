resource "azurerm_private_dns_zone" "this" {
  for_each            = local.zone_map
  name                = each.value
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each             = local.zone_map
  name                 = "${replace(each.value, ".", "-")}-link"
  private_dns_zone_id  = azurerm_private_dns_zone.this[each.key].id
  virtual_network_id   = var.vnet_id
  registration_enabled = false
  tags                 = var.tags
}
