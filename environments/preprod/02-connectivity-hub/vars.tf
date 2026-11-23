variable "environment" {
  type    = string
  default = "preprod"
  validation {
    condition     = can(regex("^(prod|preprod|uat|test)$", var.environment))
    error_message = "environment must be one of: prod, preprod, uat, test."
  }
}
variable "location" {
  type    = string
  default = "centralindia"
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", var.location))
    error_message = "location must be a valid Azure region name."
  }
}
variable "tags" {
  type = map(string)
  default = {
    env       = "preprod"
    managedBy = "terraform"
    project   = "agrikart"
  }
}
variable "lock_level" {
  type    = string
  default = "CanNotDelete"
  validation {
    condition     = var.lock_level == null || contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "lock_level must be CanNotDelete, ReadOnly, or null."
  }
}
variable "hub_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
  validation {
    condition     = alltrue([for c in var.hub_address_space : can(cidrhost(c, 0))])
    error_message = "hub_address_space must contain valid CIDR blocks."
  }
}
