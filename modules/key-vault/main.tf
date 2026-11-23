resource "azurerm_key_vault" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  sku_name                      = var.sku_name
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  tags                          = var.tags


  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_lock" "this" {
  count      = local.has_lock ? 1 : 0
  name       = "${var.name}-lock"
  scope      = azurerm_key_vault.this.id
  lock_level = var.lock_level
  notes      = "Managed by Terraform"
}
