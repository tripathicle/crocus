module "rg" {
  source     = "../../../modules/resource-group"
  name       = local.rg_name
  location   = var.location
  tags       = var.tags
  lock_level = var.lock_level
}

module "network" {
  source              = "../../../modules/networking-vnet"
  name                = "vnet-hub-test"
  location            = var.location
  resource_group_name = module.rg.name
  address_space       = var.hub_address_space
  subnets = {
    firewall = { name = "AzureFirewallSubnet", address_prefixes = ["10.0.0.0/26"] }
    bastion  = { name = "AzureBastionSubnet", address_prefixes = ["10.0.1.0/26"] }
    mgmt     = { name = "snet-mgmt", address_prefixes = ["10.0.2.0/24"] }
  }
  tags = var.tags
}

module "firewall" {
  source              = "../../../modules/azure-firewall"
  name                = "afw-hub-test"
  location            = var.location
  resource_group_name = module.rg.name
  subnet_id           = module.network.subnet_ids["firewall"]
  sku_tier            = "Standard"
  tags                = var.tags
}

module "bastion" {
  source              = "../../../modules/bastion"
  name                = "bas-hub-test"
  location            = var.location
  resource_group_name = module.rg.name
  subnet_id           = module.network.subnet_ids["bastion"]
  tags                = var.tags
}

module "dns" {
  source              = "../../../modules/private-dns"
  zones               = ["privatelink.blob.core.windows.net", "privatelink.vaultcore.azure.net", "privatelink.database.windows.net", "privatelink.redis.cache.windows.net"]
  vnet_id             = module.network.vnet_id
  resource_group_name = module.rg.name
  tags                = var.tags
}
