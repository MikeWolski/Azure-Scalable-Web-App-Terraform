output "storage_account_primary_web_endpoint" {
  description = "The primary web endpoint for the storage account."
  value       = azurerm_storage_account.storage_account.primary_web_endpoint
}

output "storage_account_container_url" {
  description = "The URL for the blob container."
  value       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.static_content.name}"
}
