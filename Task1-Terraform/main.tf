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
  name     = "test-rg-terraform"
  location = "West US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.test-rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-pip"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  frontend_ip_configuration {
    name                 = "primary"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "acctestpool"
}

resource "azurerm_network_interface" "example" {
  count               = var.nic-count
  name                = "example-nic${count.index}"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_availability_set" "test-av-set" {
  name                         = "test-availability-set"
  location                     = azurerm_resource_group.test-rg.location
  resource_group_name          = azurerm_resource_group.test-rg.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# resource "azurerm_network_interface_backend_address_pool_association" "example" {
#   network_interface_id    = azurerm_network_interface.example.id
#   ip_configuration_name   = "testconfiguration1"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
# }

resource "azurerm_network_security_group" "test-nsg" {
  name                = "test-nsg"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  #  Allow SSH to VM
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Configure a rule to allow inbound traffic from within the same virtual network (vnet). 
  # This rule enables communication between resources within the vnet.
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "Inbound_Vnet"
    priority                   = 101
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }

  # Create a rule with the lowest priority that explicitly denies all inbound traffic from the Internet. 
  # This rule ensures that no unauthorized access is allowed into your virtual machines.
  security_rule {
    access                     = "Deny"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 102
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = "*"
  }

  # Create an outbound rule to allow traffic from your virtual machines to communicate with other resources 
  # within the same vnet
  security_rule {
    access                     = "Allow"
    direction                  = "Outbound"
    name                       = "tls-outbound"
    priority                   = 103
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_range     = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  # Configure a rule to allow inbound HTTP traffic from the load balancer to your virtual 
  # This rule ensures that your VMs can receive HTTP requests from the load balancer.
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls-lb"
    priority                   = 104
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "443"
    destination_address_prefix = "VirtualNetwork"
  }

  # security_rule {
  #   access                     = "Allow"
  #   direction                  = "Inbound"
  #   name                       = "tls"
  #   priority                   = 102
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   source_address_prefix      = "*"
  #   destination_port_range     = "443"
  #   destination_address_prefix = "*"
  # }
}

resource "azurerm_network_interface_security_group_association" "test-sec-gr-asso" {
  count                     = var.nsg-count
  network_interface_id      = element(azurerm_network_interface.example.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.test-nsg.id
}

resource "azurerm_linux_virtual_machine" "test-vm" {
  count                 = var.vm-count
  name                  = "test-vm${count.index}"
  location              = azurerm_resource_group.test-rg.location
  availability_set_id   = azurerm_availability_set.test-av-set.id
  resource_group_name   = azurerm_resource_group.test-rg.name
  network_interface_ids = [azurerm_network_interface.example[count.index].id]
  size                  = "Standard_B1s"
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  admin_ssh_key {
    username   = var.vm-username
    public_key = file("~/.ssh/azure_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "myosdisk${count.index}"
  }

  computer_name  = "hostname"
  admin_username = var.vm-username
  tags = {
    Environment = "Test"
  }
}
