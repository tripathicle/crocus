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

# module "app" {
#   source = "../../modules/app"
#
#   app_service_plan = var.app_service_plan
#   linux_web_apps   = var.linux_web_apps
#   sql_servers      = var.sql_servers
#   sql_databases    = var.sql_databases
#   tags             = var.tags
# }

module "key_vault" {
  source = "../../modules/key-vault"

  key_vaults = var.key_vaults
  tags       = var.tags
}

module "internal_load_balancer" {
  source = "../../modules/lb"

  load_balancers = {
    for name, lb in var.load_balancers : name => merge(lb, {
      backend_address_pool = {
        name         = lb.backend_address_pool.name
        ip_addresses = local.backend_vm_private_ips
      }
      health_probe = merge(lb.health_probe, {
        port = 8080
      })
      lb_rule = merge(lb.lb_rule, {
        frontend_port = 8080
        backend_port  = 8080
      })
    })
  }
  tags = var.tags
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

module "public_ip" {
  source = "../../modules/public-ip"

  public_ips = var.public_ips
  tags       = var.tags
}

module "monitoring" {
  source = "../../modules/monitoring"

  log_analytics_workspaces = var.log_analytics_workspaces
  application_insights     = var.application_insights
  tags                     = var.tags
}

locals {
  frontend_vm_private_ips = [
    for key, nic in var.network_interfaces : nic.ip_configuration.private_ip_address
    if startswith(key, "frontend_") && nic.ip_configuration.private_ip_address != null
  ]
  backend_vm_private_ips = [
    for key, nic in var.network_interfaces : nic.ip_configuration.private_ip_address
    if startswith(key, "backend_") && nic.ip_configuration.private_ip_address != null
  ]
}

module "gateway" {
  source = "../../modules/gateway"

  application_gateways = {
    for name, gateway in var.application_gateways : name => merge(gateway, {
      backend_address_pool = {
        name        = gateway.backend_address_pool.name
        ip_addresses = local.frontend_vm_private_ips
      }
      health_probe = {
        name     = "agw-health-probe"
        protocol = "Http"
        port     = 80
        path     = "/"
      }
    })
  }
  tags = var.tags
}

module "private_access" {
  source = "../../modules/private-access"

  private_dns_zones = var.private_dns_zones
  private_endpoints = var.private_endpoints
  tags              = var.tags
}

module "bastion" {
  source = "../../modules/bastion"

  bastions = var.bastions
  tags     = var.tags
}

