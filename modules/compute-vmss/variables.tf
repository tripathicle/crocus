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
variable "instance_count" {
  type    = number
  default = 2
}
variable "sku" {
  type    = string
  default = "Standard_D2s_v3"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "tags" {
  type    = map(string)
  default = {}
}
