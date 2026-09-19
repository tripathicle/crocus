variable "location" {
  description = "Azure region for all resources in the dev environment. Must match the target region, compliance requirements, and service availability."
  type        = string

  validation {
    condition     = contains(["japaneast", "eastus", "eastus2", "centralus", "westeurope", "uksouth"], lower(var.location))
    error_message = "location must be a supported Azure region, for example: japaneast, eastus, eastus2, centralus, westeurope, or uksouth."
  }
}

variable "environment" {
  description = "Deployment environment name. Used for naming, tags, and policy enforcement."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], lower(var.environment))
    error_message = "environment must be one of: dev, stage, or prod."
  }
}

variable "tags" {
  description = "Default tags applied to all resources. Keep values consistent across the landing zone to support governance, ownership, and cost tracking."
  type        = map(string)
  default     = {}

  validation {
    condition = length(var.tags) == 0 || alltrue([
      for key, value in var.tags : length(trimspace(key)) > 0 && length(trimspace(value)) > 0
    ])
    error_message = "Each tag key and value must be non-empty strings to preserve consistent governance and billing metadata."
  }
}

variable "resource_groups" {
  description = "Map of resource groups to create for the dev environment. Names should be lowercase, globally unique within the subscription, and consistent with the naming convention."
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for name, rg in var.resource_groups : length(trimspace(rg.name)) > 0 && can(regex("^[A-Za-z0-9-_.]+$", rg.name))
    ])
    error_message = "Each resource group name must be non-empty and contain only letters, numbers, hyphens, underscores, or periods."
  }
}

variable "storage_accounts" {
  description = "Map of storage accounts to create for the dev environment. Values should follow Azure naming rules and enterprise storage standards."
  type = map(object({
    name                     = string
    resource_group_name      = string
    account_tier             = optional(string, "Standard")
    account_replication_type = optional(string, "LRS")
    tags                     = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, storage in var.storage_accounts : length(storage.name) >= 3 && length(storage.name) <= 24 && can(regex("^[a-z0-9]+$", storage.name)) && contains(["Standard", "Premium"], storage.account_tier) && contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RA-GRS"], storage.account_replication_type)
    ])
    error_message = "Storage account names must be 3-24 lowercase letters and numbers; account_tier must be Standard or Premium; replication type must be a valid Azure storage redundancy option."
  }
}

variable "vnets" {
  description = "Map of VNets for the hub-spoke landing zone. Each VNet must use RFC1918 private address space and valid subnet ranges."
  type = map(object({
    name                = string
    resource_group_name = string
    address_space       = list(string)
    subnets = map(object({
      name             = string
      address_prefixes = list(string)
      service_endpoints = optional(list(string), [])
    }))
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, vnet in var.vnets : length(vnet.address_space) > 0 && alltrue([for cidr in vnet.address_space : can(cidrhost(cidr, 0))]) && length(vnet.subnets) > 0
    ])
    error_message = "Each VNet must define at least one valid private CIDR and at least one subnet."
  }
}

variable "app_service_plan" {
  description = "App service plans for the 3-tier monolithic web application"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    os_type             = string
    sku_name            = string
    tags                = optional(map(string), {})
  }))
}

variable "linux_web_apps" {
  description = "Web application for the presentation layer"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    service_plan_id     = string
    https_only          = optional(bool, true)
    site_config = optional(object({
      always_on = optional(bool, true)
    }), {})
    tags = optional(map(string), {})
  }))
}

variable "sql_servers" {
  description = "SQL server for the data tier"
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    version                      = string
    administrator_login          = string
    administrator_login_password = string
    minimum_tls_version          = optional(string, "1.2")
    tags                         = optional(map(string), {})
  }))
}

variable "sql_databases" {
  description = "Database tier for the monolithic application"
  type = map(object({
    name      = string
    server_id = string
    sku_name  = string
    collation = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    tags      = optional(map(string), {})
  }))
}

variable "public_ips" {
  description = "Public IPs used for ingress and administrative access."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "Standard")
    allocation_method   = optional(string, "Static")
    zones               = optional(list(string), [])
    tags                = optional(map(string), {})
  }))
}

# variable "firewalls" {
#   description = "Azure Firewall in the hub"
#   type = map(object({
#     name                = string
#     resource_group_name = string
#     location            = string
#     sku_name            = optional(string, "AZFW_VNet")
#     sku_tier            = optional(string, "Standard")
#     firewall_policy_id  = optional(string, null)
#     subnet_id           = string
#     public_ip_id        = string
#     tags                = optional(map(string), {})
#   }))
# }

variable "load_balancers" {
  description = "Map of Azure load balancers for the backend tier"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "Standard")
    frontend_ip_configuration = object({
      name                 = string
      subnet_id            = string
      private_ip_address   = string
      private_ip_addresses = optional(list(string), [])
    })
    backend_address_pool = object({
      name = string
    })
    health_probe = object({
      name = string
      protocol = optional(string, "Tcp")
      port = number
    })
    lb_rule = object({
      name                           = string
      frontend_ip_configuration_name = string
      backend_address_pool_name      = string
      frontend_port                  = number
      backend_port                   = number
      protocol                       = optional(string, "Tcp")
      load_distribution              = optional(string, "Default")
    })
    tags = optional(map(string), {})
  }))
}

variable "key_vaults" {
  description = "Key Vault for app secrets"
  type = map(object({
    name                            = string
    resource_group_name             = string
    location                        = string
    tenant_id                       = string
    sku_name                        = optional(string, "standard")
    purge_protection_enabled        = optional(bool, true)
    soft_delete_retention_days      = optional(number, 90)
    enable_rbac_authorization       = optional(bool, true)
    public_network_access_enabled   = optional(bool, true)
    tags                            = optional(map(string), {})
  }))
}

variable "network_security_groups" {
  description = "NSGs for ingress and app traffic. Rules must be explicit, ordered, and least-privilege by design."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string, "*")
      destination_port_range     = optional(string, "*")
      source_address_prefix      = optional(string, "*")
      destination_address_prefix = optional(string, "*")
    }))
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, nsg in var.network_security_groups : length(trimspace(nsg.name)) > 0 && alltrue([
        for rule_key, rule in nsg.security_rules : rule.priority >= 100 && rule.priority <= 4096 && contains(["Inbound", "Outbound"], rule.direction) && contains(["Allow", "Deny"], rule.access)
      ])
    ])
    error_message = "Each NSG name must be non-empty; every security rule priority must be between 100 and 4096 and include valid direction and access values."
  }
}

variable "log_analytics_workspaces" {
  description = "Log Analytics workspace for centralized diagnostics and monitoring."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
    tags                = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, workspace in var.log_analytics_workspaces : length(trimspace(workspace.name)) > 0 && workspace.retention_in_days >= 30 && workspace.retention_in_days <= 730
    ])
    error_message = "Log Analytics names must be non-empty and retention_in_days should be between 30 and 730 days."
  }
}

variable "application_insights" {
  description = "Application Insights resource for application telemetry and observability."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    workspace_id        = string
    application_type    = optional(string, "web")
    tags                = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, appi in var.application_insights : length(trimspace(appi.name)) > 0 && contains(["web", "other"], lower(appi.application_type))
    ])
    error_message = "Application Insights names must be non-empty and application_type must be web or other."
  }
}

variable "application_gateways" {
  description = "Application Gateway for public ingress and TLS termination. Keep traffic patterns explicit and compliant with enterprise network rules."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    gateway_ip_configuration = object({
      name      = string
      subnet_id = string
    })
    frontend_ip_configuration = object({
      name                 = string
      public_ip_address_id = string
    })
    frontend_port = object({
      name = string
      port = number
    })
    http_listener = object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
    })
    request_routing_rule = object({
      name                       = string
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    })
    backend_address_pool = object({
      name        = string
      ip_addresses = optional(list(string), [])
    })
    backend_http_settings = object({
      name                  = string
      cookie_based_affinity = string
      port                  = number
      protocol              = string
      request_timeout       = number
    })
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, gateway in var.application_gateways : length(trimspace(gateway.name)) > 0 && gateway.sku.capacity >= 1 && gateway.frontend_port.port >= 1 && gateway.frontend_port.port <= 65535
    ])
    error_message = "Application Gateway names must be non-empty, capacity must be at least 1, and frontend ports must be valid TCP/UDP ports."
  }
}

variable "network_interfaces" {
  description = "NIC definitions for VM attachments. IP configuration values must be valid and specific to the target subnet."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    ip_configuration = object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string, null)
    })
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, nic in var.network_interfaces : length(trimspace(nic.name)) > 0 && contains(["Dynamic", "Static"], nic.ip_configuration.private_ip_address_allocation)
    ])
    error_message = "NIC names must be non-empty and private IP allocation must be Dynamic or Static."
  }
}

variable "linux_virtual_machines" {
  description = "Linux VM definitions for the workload tier. Passwords and admin values must be managed securely and never hardcoded in source control."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    size                = string
    admin_username      = string
    admin_password      = string
    network_interface_id = string
    custom_data         = optional(string, null)
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, vm in var.linux_virtual_machines : length(trimspace(vm.name)) > 0 && length(trimspace(vm.admin_username)) > 0 && (length(trimspace(coalesce(vm.admin_password, ""))) >= 12 || vm.admin_ssh_key != null) && length(trimspace(vm.size)) > 0
    ])
    error_message = "VM names and admin usernames must be non-empty; either a secure password of at least 12 characters or an SSH key must be supplied, and size must be defined."
  }
}

variable "subnet_network_security_group_associations" {
  description = "Subnet-to-NSG associations. Each association must map a valid subnet to a valid NSG."
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))

  validation {
    condition = alltrue([
      for key, association in var.subnet_network_security_group_associations : length(trimspace(association.subnet_id)) > 0 && length(trimspace(association.network_security_group_id)) > 0
    ])
    error_message = "Every subnet-to-NSG association must include both a valid subnet ID and a valid NSG ID."
  }
}

variable "private_dns_zones" {
  description = "Private DNS zones used for Azure PaaS private access. Keep zone names aligned with the private endpoint design."
  type = map(object({
    name                = string
    resource_group_name = string
    tags                = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, zone in var.private_dns_zones : length(trimspace(zone.name)) > 0 && can(regex("\\.$", zone.name))
    ])
    error_message = "Private DNS zone names must be non-empty and fully qualified domain names."
  }
}

variable "private_endpoints" {
  description = "Private endpoints for Azure SQL and other PaaS services. Private access must be explicitly controlled and documented."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    private_service_connection = object({
      name                           = string
      private_connection_resource_id = string
      is_manual_connection           = optional(bool, false)
      subresource_names              = list(string)
      request_message                = optional(string, null)
    })
    private_dns_zone_group = optional(object({
      name                = string
      private_dns_zone_ids = list(string)
    }), null)
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, endpoint in var.private_endpoints : length(trimspace(endpoint.name)) > 0 && length(trimspace(endpoint.subnet_id)) > 0 && length(endpoint.private_service_connection.subresource_names) > 0
    ])
    error_message = "Private endpoint names, subnet IDs, and service connection subresource names must be defined."
  }
}

variable "bastions" {
  description = "Azure Bastion hosts for secure administrative access. Public access should be restricted to approved network paths only."
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    subnet_id            = string
    public_ip_address_id = string
    tags                 = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for key, bastion in var.bastions : length(trimspace(bastion.name)) > 0 && length(trimspace(bastion.subnet_id)) > 0 && length(trimspace(bastion.public_ip_address_id)) > 0
    ])
    error_message = "Bastion names, subnet IDs, and public IP IDs must be defined for secure access."
  }
}
