variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "MWProject2RG"
}

variable "location" {
  description = "The Azure region where the resources should be created"
  type        = string
  default     = "Central US"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "Project2VNET"
}

variable "address_space" {
  description = "The address space for the virtual network"
  default     = ["10.0.0.0/16"]
}

variable "web_subnet_name" {
  description = "The name of the web subnet"
  type        = string
  default     = "WebSubnet"
}

variable "web_subnet_cidr" {
  description = "The CIDR block for the web subnet"
  default     = ["10.0.0.0/24"]
}

variable "db_subnet_name" {
  description = "The name of the database subnet"
  type        = string
  default     = "DBSubnet"
}

variable "db_subnet_cidr" {
  description = "The CIDR block for the database subnet"
  default     = ["10.0.1.0/24"]
}

variable "initial_instance_count" {
  description = "The number of web VMs to deploy"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "The admin username for the VMs"
  type        = string
  default     = "Mike"
}

variable "db_admin_password" {
  description = "The admin password for the SQL Server"
  type        = string
  default     = "ChangeM3N0w!"
}

variable "db_admin_username" {
  description = "The admin username for the SQL Server"
  type        = string
  default     = "sqladmin"
}
