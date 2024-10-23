resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}

# Storage container for static content (e.g., images, CSS, etc.)
resource "azurerm_storage_container" "static_content" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "blob"
}
