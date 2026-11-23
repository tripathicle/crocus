module "rg" {
  source     = "../../../modules/resource-group"
  name       = local.rg_name
  location   = var.location
  tags       = var.tags
  lock_level = var.lock_level
}

module "monitoring" {
  source              = "../../../modules/monitoring-observability"
  name                = "log-preprod"
  location            = var.location
  resource_group_name = module.rg.name
  tags                = var.tags
}

module "kv" {
  source              = "../../../modules/key-vault"
  name                = "kv-mgmt-preprod"
  location            = var.location
  resource_group_name = module.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
  lock_level          = var.lock_level
}
