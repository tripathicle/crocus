variable "server_name" { type = string }
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
  default = "sqladmin"
}
variable "database_name" { type = string }
variable "sku_name" {
  type    = string
  default = "GP_Gen5_2"
}
variable "zone_redundant" {
  type    = bool
  default = true
  validation {
    condition     = contains([true, false], var.zone_redundant)
    error_message = "zone_redundant must be true or false."
  }
}
variable "failover_group_name" {
  type    = string
  default = null
}
variable "secondary_location" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}

