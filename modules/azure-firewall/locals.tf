locals {
  sku_name = var.sku_tier == "Premium" ? "AZFW_VNet" : "AZFW_VNet"
}
