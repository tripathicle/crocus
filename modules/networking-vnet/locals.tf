locals {
  subnet_list = [for k, v in var.subnets : v]
}
