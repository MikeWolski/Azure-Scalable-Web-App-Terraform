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
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 4
  load_distribution              = "Default"
  probe_id                       = azurerm_lb_probe.http_probe.id
  depends_on = [azurerm_lb_probe.http_probe]
}

# VMSS Autoscale
resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {
  name                = "vmss-autoscale"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id
  enabled             = true
  depends_on = [azurerm_linux_virtual_machine_scale_set.vmss,]

  profile {
    name = "defaultProfile"

    capacity {
      minimum = "2"
      maximum = "5"
      default = "2"
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "apache_install" {
  name                 = "install-apache"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.vmss.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "commandToExecute": "sleep 300 && sudo apt-get update && sudo apt-get install -y apache2 && sudo systemctl start apache2 && sudo systemctl enable apache2"
    }
  SETTINGS
}


# Health Probe
resource "azurerm_lb_probe" "http_probe" {
  name                = "http-health-probe"
  loadbalancer_id     = azurerm_lb.load_balancer.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}
