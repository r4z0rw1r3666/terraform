#Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "${var.resource_prefix}${var.resource_name}PublicIP"
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
    name = "${var.resource_prefix}${var.resource_name}NSG"
    location = var.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    
    security_rule {
        name = "SSH"
        priority = 1002
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "80,443,20,21"
        destination_port_range = "80,443,20,21"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    
}



#Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "${var.resource_prefix}${var.resource_name}NIC"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.resource_prefix}${var.resource_name}NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

#Create Linux VM
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.resource_prefix}${var.resource_name}VM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name = "${var.resource_prefix}${var.resource_name}OSDisk"
        caching = "ReadWrite"
        create_option = "FromImage"
        managed_disk_type = "Premium_LRS"

    }
    storage_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = var.sku
        version = "latest"

    }
    os_profile {
        computer_name = "${var.resource_prefix}${var.resource_name}VM"
        admin_username = var.admin_username
        admin_password = var.admin_password

    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    tags = {
            owner = "user"
            environment = "development"
    }

}

