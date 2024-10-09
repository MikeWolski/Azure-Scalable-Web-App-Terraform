variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "MWProject2"
}

variable "location" {
  description = "The Azure region where the resources should be created"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "WolskNET"
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "web_subnet_name" {
  description = "The name of the web subnet"
  type        = string
  default     = "WebSubnet"
}

variable "web_subnet_cidr" {
  description = "The CIDR block for the web subnet"
  type        = string
  default     = ["10.0.0.0/24"]
}

variable "db_subnet_name" {
  description = "The name of the database subnet"
  type        = string
  default     = "DBSubnet"
}

variable "db_subnet_cidr" {
  description = "The CIDR block for the database subnet"
  type        = string
  default     = ["10.0.1.0/24"]
}
