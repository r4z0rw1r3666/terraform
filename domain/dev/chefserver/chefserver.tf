

#Create Linux VM
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-${var.resource_name}VM"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = var.ip_address_name
  vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name = "${var.prefix}-${var.resource_name}OSDisk"
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
        computer_name = "${var.prefix}-${var.resource_name}VM"
        admin_username = var.admin_username
        admin_password = var.admin_password
    }
    
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

#Create network security group and rules
resource "azurerm_network_security_group" "nsg" {
    name = "${var.prefix}-${var.resource_name}NSG"
    location = var.location
    resource_group_name = var.resource_group

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
    
}