variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region"
  type        = string
}

variable "initial_instance_count" {
  description = "The number of virtual machines to create"
  type        = number
}

variable "vm_name_prefix" {
  description = "The prefix for the virtual machine names"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the VMs will be deployed"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machines"
  type        = string
  default     = "Mike"
}

variable "admin_password" {
  description = "The admin password for the virtual machines"
  type        = string
  sensitive   = true
  default     = "Skilling123!"
}

variable "frontend_ip_config" {
  description = "The name of the frontend IP configuration"
  type        = string
}

variable "backend_address_pool_name" {
  description = "The name of the backend address pool"
  type        = string
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key to be used for VM authentication"
  type        = string
}
