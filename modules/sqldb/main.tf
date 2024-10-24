# Create a managed instance and a managed database in Azure SQL Database
resource "azurerm_mssql_managed_instance" "sql_managed_instance" {
  name                         = var.db_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  subnet_id                    = var.db_subnet_id
  sku_name                     = var.sku_name
  storage_size_in_gb           = 32
  vcores                       = 4
  collation                    = "SQL_Latin1_General_CP1_CI_AS"
  license_type                 = "LicenseIncluded"
  public_data_endpoint_enabled = false
  depends_on                   = [ azurerm_subnet_route_table_association.routetableassociation ]
}

# Create a managed database in the managed instance
resource "azurerm_sql_managed_database" "sql_managed_db" {
  name                   = "project2-db"
  managed_instance_id    = azurerm_mssql_managed_instance.sql_managed_instance.id
  collation              = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb            = 32
  depends_on             = [ azurerm_mssql_managed_instance.sql_managed_instance ]
}

resource "azurerm_network_security_rule" "allow_management_inbound" {
  name                        = "allow_management_inbound"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
  name                        = "allow_misubnet_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
  name                        = "allow_health_probe_inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "allow_tds_inbound" {
  name                        = "allow_tds_inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny_all_inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "allow_management_outbound" {
  name                        = "allow_management_outbound"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
  name                        = "allow_misubnet_outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  name                        = "deny_all_outbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = "${var.db_subnet_name}-nsg"
}

resource "azurerm_route_table" "routetable" {
  name                          = "routetable-mi"
  location                      = var.location
  resource_group_name           = var.resource_group_name
}

resource "azurerm_subnet_route_table_association" "routetableassociation" {
  subnet_id      = var.db_subnet_id
  route_table_id = azurerm_route_table.routetable.id
}

