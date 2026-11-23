output "id" { value = local.is_linux ? azurerm_linux_virtual_machine_scale_set.this[0].id : azurerm_windows_virtual_machine_scale_set.this[0].id }
output "name" { value = var.name }
