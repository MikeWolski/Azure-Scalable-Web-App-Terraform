# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "7fdf605c-e6b5-4f51-b9c0-27d0799ce221"
}

# Define the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Call the VNet module
module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  web_subnet_name     = var.web_subnet_name
  web_subnet_cidr     = var.web_subnet_cidr
  db_subnet_name      = var.db_subnet_name
  db_subnet_cidr      = var.db_subnet_cidr
}

# Call the NSG module for the web subnet
module "web_nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  nsg_name            = "${var.web_subnet_name}-nsg"
  subnet_id           = module.vnet.web_subnet_id
}

# Call the NSG module for the database subnet
module "db_nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  nsg_name            = "${var.db_subnet_name}-nsg"
  subnet_id           = module.vnet.db_subnet_id
}

# Deploy VMSS with LB for the web tier
module "web_vmss_with_lb" {
  source              = "./modules/vmsslb"
  vm_name_prefix      = "webvm"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.vnet.web_subnet_id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  initial_instance_count = 2
  frontend_ip_config  = "web-lb-ip"
  backend_address_pool_name = "web-backend-pool"
  ssh_public_key_path   = "~/.ssh/id_rsa.pub"
}

