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
variable "resource_group_name" { type = string }
variable "subnet_id" { type = string }
variable "sku_tier" {
  type    = string
  default = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be Standard or Premium."
  }
}
variable "tags" {
  type    = map(string)
  default = {}
}
