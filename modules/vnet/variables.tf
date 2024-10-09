variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources should be created"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "web_subnet_name" {
  description = "The name of the web subnet"
  type        = string
}

variable "web_subnet_cidr" {
  description = "The CIDR block for the web subnet"
  type        = string
}

variable "db_subnet_name" {
  description = "The name of the database subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "The CIDR block for the database subnet"
  type        = string
}
