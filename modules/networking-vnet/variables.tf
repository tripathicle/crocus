variable "name" {
  type = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{2,23}$", var.name))
    error_message = "name must be 3-24 chars, alphanumeric or hyphen."
  }
}

variable "location" {
  type = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", var.location))
    error_message = "location must be a valid Azure region name."
  }
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
  validation {
    condition     = alltrue([for c in var.address_space : can(cidrhost(c, 0))])
    error_message = "address_space must contain valid CIDR blocks."
  }
}

variable "subnets" {
  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation        = optional(string, null)
  }))
  default = {}
}

variable "nsg_rules" {
  type = map(object({
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
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_ddos" {
  type    = bool
  default = false
}

variable "peerings" {
  type = map(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, true)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = {}
  validation {
    condition     = alltrue([for p in var.peerings : can(regex("^/subscriptions/.+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+$", p.remote_virtual_network_id))])
    error_message = "peerings remote_virtual_network_id must be a valid VNet resource ID."
  }
}
