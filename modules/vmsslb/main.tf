# Create Public IP for the load balancer
resource "azurerm_public_ip" "lb_ip" {
  name                = var.frontend_ip_config
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# Create Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = "web-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = var.frontend_ip_config
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

# Create Backend Pool for the load balancer
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name                = "web-backend-pool"
  loadbalancer_id     = azurerm_lb.load_balancer.id
}

# VM Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "web-vmss"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_B2s"
  instances           = var.initial_instance_count
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  network_interface {
    name    = "nic-vmss"
    primary = true

    ip_configuration {
      name                                   = "ipconfig1"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

# Load Balancer Rule (for HTTP traffic)
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "HTTP"
  loadbalancer_id                = azurerm_lb.load_balancer.id
  frontend_ip_configuration_name = azurerm_lb.load_balancer.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 4
  load_distribution              = "Default"
}
