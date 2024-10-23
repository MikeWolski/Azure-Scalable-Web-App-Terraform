resource "azurerm_sql_server" "sql_server" {
  name                         = "${var.db_name}-server"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  # Enable VNet Service Endpoints for SQL
  public_network_access_enabled = false
}

resource "azurerm_sql_database" "sql_db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
  sku_name            = var.sku_name

  # Configure additional settings as needed
  collation           = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb         = 5
  zone_redundant      = false
}

# Virtual Network rule to secure access to the database from the DB subnet
resource "azurerm_sql_virtual_network_rule" "vnet_rule" {
  name                = "allow-db-subnet"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  subnet_id           = var.db_subnet_id
}

# Firewall rule to allow access only from the DB subnet
resource "azurerm_sql_firewall_rule" "firewall_rule" {
  name                = "allow-db-subnet"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = var.db_subnet_ip_range_start
  end_ip_address      = var.db_subnet_ip_range_end
}
