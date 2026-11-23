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
variable "sku_name" {
  type    = string
  default = "P1v3"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "app_names" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
