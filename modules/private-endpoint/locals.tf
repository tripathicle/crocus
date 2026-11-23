locals {
  has_dns = length(var.private_dns_zone_ids) > 0
}
