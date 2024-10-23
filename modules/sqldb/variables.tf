variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure db location"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the SQL Managed Instance"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the SQL Managed Instance"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the SQL Managed Instance"
  type        = string
}

variable "sku_name" {
  description = "The SKU for the SQL Managed Instance"
  type        = string
  default     = "GP_Gen5"
}

variable "db_subnet_id" {
  description = "The ID of the database subnet for VNet integration"
  type        = string
}

variable "db_subnet_name" {
  description = "The name of the database subnet"
  type        = string
}

variable "db_nsg_id" {
  description = "The ID of the database subnet for VNet integration"
  type        = string
}