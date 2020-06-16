# Create a new resource group
resource "azurerm_resource_group" "main" {
    name     = "${var.resource_prefix}-resources"
    location = var.location
}

#Creating a Vnet - Public
resource "azurerm_virtual_network" "main" {
    name = "${var.resource_prefix}-Vnet"
    resource_group_name = azurerm_resource_group.main.name
    location = var.location
    address_space = ["10.0.0.0/16"]
}

#Create internal subnet
resource "azurerm_subnet" "internal" {
    name = "internal"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefix = "10.0.2.0/24"
}

#Create public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.resource_prefix}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

data "azurerm_public_ip" "main" {
    name = azurerm_public_ip.main.name
    resource_group_name = azurerm_resource_group.main.name
}

#Create internal network
resource "azurerm_network_interface" "main" {
    name = "${var.resource_prefix}-nic"
    resource_group_name = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.internal.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.main.id
    }
}
