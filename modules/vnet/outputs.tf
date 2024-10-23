# Output Subnet IDs
output "web_subnet_id" {
  value = azurerm_subnet.web_subnet.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "db_subnet_name" {
  value = azurerm_subnet.db_subnet.name
}