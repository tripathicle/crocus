locals {
  mode = var.ha_enabled ? "ZoneRedundant" : "Disabled"
}
