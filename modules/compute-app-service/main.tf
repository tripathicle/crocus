resource "azurerm_service_plan" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  for_each            = var.os_type == "Linux" ? local.app_map : {}
  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true
  tags                = var.tags

  site_config {
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_windows_web_app" "this" {
  for_each            = var.os_type == "Windows" ? local.app_map : {}
  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true
  tags                = var.tags

  site_config {
    minimum_tls_version = "1.2"
  }
}
