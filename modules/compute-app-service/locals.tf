locals {
  app_map = { for a in var.app_names : a => a }
}
