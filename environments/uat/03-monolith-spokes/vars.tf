variable "environment" {
  type    = string
  default = "uat"
  validation {
    condition     = can(regex("^(prod|preprod|uat|test)$", var.environment))
    error_message = "environment must be one of: prod, preprod, uat, test."
  }
}
variable "primary_region" {
  type    = string
  default = "centralindia"
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", var.primary_region))
    error_message = "location must be a valid Azure region name."
  }
}
variable "dr_region" {
  type    = string
  default = "southindia"
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", var.dr_region))
    error_message = "location must be a valid Azure region name."
  }
}
variable "enable_dr" {
  type    = bool
  default = false
  validation {
    condition     = contains([true, false], var.enable_dr)
    error_message = "enable_dr must be true or false."
  }
}
variable "tags" {
  type = map(string)
  default = {
    env       = "uat"
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
variable "monolith_apps" {
  type = map(object({
    name      = string
    sku       = optional(string, "P1v3")
    instances = optional(number, 2)
  }))
  default = {
    erp-core        = { name = "agrikart-web" }
    billing-suite   = { name = "agrikart-api" }
    customer-portal = { name = "agrikart-admin" }
  }
  validation {
    condition     = contains(keys(var.monolith_apps), "erp-core") && contains(keys(var.monolith_apps), "billing-suite") && contains(keys(var.monolith_apps), "customer-portal")
    error_message = "monolith_apps must include erp-core, billing-suite, and customer-portal."
  }
}
