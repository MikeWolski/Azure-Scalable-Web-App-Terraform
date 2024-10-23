variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the SQL Server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the SQL Server"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the SQL Database"
  type        = string
}

variable "sku_name" {
  description = "The SKU for the SQL Database"
  type        = string
  default     = "Basic"
}

variable "db_subnet_id" {
  description = "The ID of the database subnet for VNet integration"
  type        = string
}

variable "db_subnet_ip_range_start" {
  description = "Start IP range for the firewall rule (DB subnet)"
  type        = string
}

variable "db_subnet_ip_range_end" {
  description = "End IP range for the firewall rule (DB subnet)"
  type        = string
}
