module "spoke_rg" {
  source   = "../../../modules/resource-group"
  for_each = local.spoke_map

  name       = each.value.rg_name
  location   = each.value.region
  tags       = var.tags
  lock_level = var.lock_level
}

module "spoke_network" {
  source   = "../../../modules/networking-vnet"
  for_each = local.spoke_map

  name                = "vnet-spoke-${each.value.app_name}-${each.value.region}"
  location            = each.value.region
  resource_group_name = module.spoke_rg[each.key].name
  address_space       = ["10.10.0.0/16"]
  subnets = {
    app = { name = "snet-app", address_prefixes = ["10.10.1.0/24"] }
    db  = { name = "snet-db", address_prefixes = ["10.10.2.0/24"] }
  }
  tags = var.tags
  peerings = {
    hub = {
      name                      = "peer-spoke-to-hub"
      remote_virtual_network_id = data.azurerm_virtual_network.hub.id
    }
  }
}

module "spoke_app" {
  source   = "../../../modules/compute-app-service"
  for_each = local.spoke_map

  name                = "asp-${each.value.app_name}-${each.value.region}"
  location            = each.value.region
  resource_group_name = module.spoke_rg[each.key].name
  sku_name            = each.value.sku
  os_type             = "Linux"
  app_names           = ["app-${each.value.app_name}-${each.value.region}"]
  tags                = var.tags
}

module "spoke_storage" {
  source   = "../../../modules/storage-account"
  for_each = local.spoke_map

  name                = "stagrikart${replace(each.value.app_name, "-", "")}${substr(each.value.region, 0, 4)}"
  location            = each.value.region
  resource_group_name = module.spoke_rg[each.key].name
  containers          = ["product-images", "uploads", "logs"]
  tags                = var.tags
  lock_level          = var.lock_level
}

module "spoke_kv" {
  source   = "../../../modules/key-vault"
  for_each = local.spoke_map

  name                = "kv-spoke-${each.value.app_name}-${substr(each.value.region, 0, 4)}"
  location            = each.value.region
  resource_group_name = module.spoke_rg[each.key].name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
  lock_level          = var.lock_level
}
