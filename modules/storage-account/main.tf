resource "azurerm_storage_account" "this" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  account_tier                  = var.account_tier
  account_replication_type      = var.replication_type
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = false
  shared_access_key_enabled     = false
  tags                          = var.tags


  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "this" {
  for_each              = local.container_map
  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_management_lock" "this" {
  count      = local.has_lock ? 1 : 0
  name       = "${var.name}-lock"
  scope      = azurerm_storage_account.this.id
  lock_level = var.lock_level
  notes      = "Managed by Terraform"
}
