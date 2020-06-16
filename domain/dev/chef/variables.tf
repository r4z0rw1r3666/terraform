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
variable "resource_prefix" {
  type = string
  default = "Development"
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


# Configure the Azure provider
provider "azurerm" {
    version = "=1.32.1"
}

variable "tags" {
  type = map

  default = {
      Environment = "Development"
  }
    
}

