# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = "${var.resource_prefix}${var.resource_domain}"
    location = var.location

}

#Creating a Vnet
resource "azurerm_virtual_network" "vnet" {
    name = "${var.resource_prefix}${var.resource_domain}Vnet"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    address_space = ["10.0.0.0/16"]
}

#Create subnet
resource "azurerm_subnet" "subnet" {
    name = "${var.resource_prefix}${var.resource_domain}Subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "10.0.1.0/24"
}

#Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "${var.resource_prefix}${var.resource_domain}PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

data "azurerm_public_ip" "publicip" {
    name = azurerm_public_ip.publicip.name
    resource_group_name = azurerm_resource_group.rg.name
}

#Create network security group and rules
resource "azurerm_network_security_group" "nsg" {
    name = "${var.resource_prefix}${var.resource_domain}NSG"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name
}




