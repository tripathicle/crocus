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
variable "administrator_login" {
  type    = string
  default = "pgadmin"
}
variable "sku_name" {
  type    = string
  default = "GP_Standard_D2s_v3"
}
variable "storage_mb" {
  type    = number
  default = 32768
}
variable "postgres_version" {
  type    = string
  default = "16"
}
variable "ha_enabled" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}

