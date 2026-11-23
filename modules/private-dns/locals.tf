locals {
  zone_map = { for z in var.zones : z => z }
}
