output "sql_server_fqdn" {
  value       = azurerm_sql_server.sql_server.fully_qualified_domain_name
  description = "The FQDN of the SQL Server"
}

output "sql_database_id" {
  value       = azurerm_sql_database.sql_db.id
  description = "The ID of the SQL Database"
}
