variable "environment" {
  type    = string
  default = "test"
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
    env       = "test"
    managedBy = "terraform"
    project   = "agrikart"
  }
}
variable "lock_level" {
  type    = string
  default = null
  validation {
    condition     = var.lock_level == null || contains(["CanNotDelete", "ReadOnly"], var.lock_level)
    error_message = "lock_level must be CanNotDelete, ReadOnly, or null."
  }
}
