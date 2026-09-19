variable "subnet_network_security_group_associations" {
  description = "Map of subnet-to-NSG associations"
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))
  default = {}
}
