# Task 1: Creating an ubuntu vm. 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "test-rg" {
  name     = "test-rg"
  location = "West US"
}

resource "azurerm_virtual_network" "test-vn" {
  name                = "test-vn"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
}

resource "azurerm_subnet" "test-subnet" {
  name                 = "test-subent"
  resource_group_name  = azurerm_resource_group.test-rg.name
  virtual_network_name = azurerm_virtual_network.test-vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "test-publicIp" {
  name                = "test-public-ip"
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "test-nic-main" {
  name                = "test-nic-main"
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.test-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.test-publicIp.id
  }
}

resource "azurerm_network_interface" "test-nic-internal" {
  name                = "test-nic-internal"
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "test-net-sec-gr" {
  name                = "test-network-sec-gr"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  #   security_rule {
  #     access                       = "Allow"
  #     direction                    = "Inbound"
  #     name                         = "Ssh"
  #     priority                     = 100
  #     protocol                     = "ssh"
  #     source_port_range            = "*"
  #     source_address_prefix        = "*"
  #     destination_port_range       = "22"
  #     destination_address_prefixes = azurerm_network_interface.test-nic-main.private_ip_addresses
  #   }

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "tls"
    priority                     = 101
    protocol                     = "Tcp"
    source_port_range            = "*"
    source_address_prefix        = "*"
    destination_port_range       = "443"
    destination_address_prefixes = azurerm_network_interface.test-nic-main.private_ip_addresses
  }
}

resource "azurerm_network_interface_security_group_association" "test-sec-gr-asso" {
  network_interface_id      = azurerm_network_interface.test-nic-internal.id
  network_security_group_id = azurerm_network_security_group.test-net-sec-gr.id
}

resource "azurerm_linux_virtual_machine" "test-vm" {
  name                  = "test-vm"
  resource_group_name   = azurerm_resource_group.test-rg.name
  location              = azurerm_resource_group.test-rg.location
  size                  = "Standard_F2"
  admin_username        = "adminUser"
  network_interface_ids = [azurerm_network_interface.test-nic-main.id]
  admin_ssh_key {
    username   = "adminUser"
    public_key = file("~/.ssh/azure_rsa.pub")
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

}
