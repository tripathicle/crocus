module "rg" {
  source     = "../../../modules/resource-group"
  name       = local.rg_name
  location   = var.location
  tags       = var.tags
  lock_level = var.lock_level
}

module "appgw" {
  source              = "../../../modules/app-gateway-waf"
  name                = "appgw-uat"
  location            = var.location
  resource_group_name = module.rg.name
  subnet_id           = data.azurerm_subnet.appgw.id
  tags                = var.tags
}

module "frontdoor" {
  source              = "../../../modules/front-door-global"
  name                = "afd-uat"
  resource_group_name = module.rg.name
  tags                = var.tags
}

module "backup" {
  source              = "../../../modules/backup-vault"
  name                = "rsv-uat"
  location            = var.location
  resource_group_name = module.rg.name
  tags                = var.tags
}

module "sqldb" {
  source              = "../../../modules/database-sql"
  server_name         = "sql-uat"
  location            = var.location
  resource_group_name = module.rg.name
  database_name       = "agrikart"
  failover_group_name = null
  secondary_location  = null
  tags                = var.tags
}
