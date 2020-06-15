# Variable for ResourceType -- dev/test/prod
variable "resource_prefix" {
  type = string
  default = "Development"
}

# Variable for ResourceName
variable "resource_domain" {
  type = string
  default = "HISS"

}
# Variable for location
variable "location" {}
  
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

