# Variable for admin username
variable "admin_username" {
  type = string
  description = "Administrator for VM"
}

# Variable for admin password
variable "admin_password" {
  type = string
  description = "Password for VM"
}

# Variable for ResourceType -- dev/test/prod
variable "prefix" {
  type = string
  default = "Dev"
}

# Variable for ResourceName
variable "resource_name" {
  type = string
  default = "ChefServer"

}
# Variable for location
variable "location" {}
  
variable "sku" {
  type = string
  default = "18.04-LTS"
}

variable "resource_group" {
  type = string
  default = "dev-resources"
}

variable "ip_address_name" {
  type = string
  default = "domain-clients"
}

variable "azure_subscription_id" {}

# Configure the Azure provider
provider "azurerm" {
    version = "=1.32.1"
    subscription_id = var.azure_subscription_id
}

variable "tags" {
  type = map

  default = {
      Environment = "Development"
  }
    
}

