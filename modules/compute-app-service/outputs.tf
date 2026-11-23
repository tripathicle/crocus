output "plan_id" { value = azurerm_service_plan.this.id }
output "plan_name" { value = azurerm_service_plan.this.name }
output "app_ids" { value = var.os_type == "Linux" ? { for k, v in azurerm_linux_web_app.this : k => v.id } : { for k, v in azurerm_windows_web_app.this : k => v.id } }
