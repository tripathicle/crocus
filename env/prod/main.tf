module "resource_groups" {
  source = "../../modules/rg"

  location        = var.location
  tags            = var.tags
  resource_groups = var.resource_groups
}

module "storage_accounts" {
  source = "../../modules/sa"

  location         = var.location
  tags             = var.tags
  storage_accounts = var.storage_accounts
}

module "network" {
  source = "../../modules/network"

  location = var.location
  tags     = var.tags
  vnets    = var.vnets
}

module "internal_load_balancer" {
  source = "../../modules/lb"

  load_balancers = var.load_balancers
  tags           = var.tags
}

module "nsg" {
  source = "../../modules/nsg"

  network_security_groups = var.network_security_groups
  tags                    = var.tags
}

module "nic" {
  source = "../../modules/nic"

  network_interfaces = var.network_interfaces
  tags               = var.tags
}

module "vm" {
  source = "../../modules/vm"

  linux_virtual_machines = var.linux_virtual_machines
  tags                   = var.tags
}

module "nsg_association" {
  source = "../../modules/nsg-association"

  subnet_network_security_group_associations = var.subnet_network_security_group_associations
}

module "monitoring" {
  source = "../../modules/monitoring"

  log_analytics_workspaces = var.log_analytics_workspaces
  application_insights     = var.application_insights
  tags                     = var.tags
}

module "gateway" {
  source = "../../modules/gateway"

  application_gateways = var.application_gateways
  tags                 = var.tags
}

module "bastion" {
  source = "../../modules/bastion"

  bastions = var.bastions
  tags     = var.tags
}
