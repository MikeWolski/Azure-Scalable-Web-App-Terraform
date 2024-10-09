variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources should be created"
  type        = string
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the NSG"
  type        = string
}
