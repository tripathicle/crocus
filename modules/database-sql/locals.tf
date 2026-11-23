locals {
  has_failover = var.failover_group_name != null && var.secondary_location != null
}
