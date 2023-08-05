terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    #   skip_provider_registration = true # This is only required when the User, Service Principal, 
    #   or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  }
}

# Task 1 - Create resource group
resource "azurerm_resource_group" "taskRG" {
  name     = "resource-group-west"
  location = "West US"
  tags = {
    "ENV" = "DEV"
  }
}

# Task 2- Create a VM Linux vm
# resource "azurerm_virtual_network" "virNet" {
#   name                = "Dev-vir-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = azurerm_resource_group.taskRG.location
#   resource_group_name = azurerm_resource_group.taskRG.name
# }

# resource "azurerm_subnet" "virtualSubnet" {
#   name                 = "Dev-subnet"
#   resource_group_name  = azurerm_resource_group.taskRG.name
#   virtual_network_name = azurerm_virtual_network.virNet.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# resource "azurerm_public_ip" "virtualPub" {
#   name                = "VM-publicIp"
#   resource_group_name = azurerm_resource_group.taskRG.name
#   location            = azurerm_resource_group.taskRG.location
#   allocation_method   = "Dynamic"
# }

# resource "azurerm_network_interface" "virtualNIMain" {
#   name                = "DEV-NI-Main"
#   resource_group_name = azurerm_resource_group.taskRG.name
#   location            = azurerm_resource_group.taskRG.location
#   ip_configuration {
#     name                          = "NI-Primary"
#     subnet_id                     = azurerm_subnet.virtualSubnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.virtualPub.id
#   }
# }

# resource "azurerm_network_security_group" "virtualSECG" {
#   name                = "DEV-network-SEC-Group"
#   location            = azurerm_resource_group.taskRG.location
#   resource_group_name = azurerm_resource_group.taskRG.name
#   security_rule {
#     access                     = "Allow"
#     direction                  = "Inbound"
#     name                       = "tls"
#     priority                   = 100
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     source_address_prefix      = "*"
#     destination_port_range     = "443"
#     destination_address_prefix = azurerm_network_interface.virtualNIMain.private_ip_address
#   }
#   security_rule {
#     name                       = "allow_SSH"
#     description                = "Allow SSH access"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# resource "azurerm_network_interface_security_group_association" "virtualSecAsso" {
#   network_interface_id      = azurerm_network_interface.virtualNIMain.id
#   network_security_group_id = azurerm_network_security_group.virtualSECG.id
# }

# resource "azurerm_linux_virtual_machine" "virtuaMachine" {
#   name                = "DEV-VM"
#   resource_group_name = azurerm_resource_group.taskRG.name
#   location            = azurerm_resource_group.taskRG.location
#   size                = "Standard_F2"
#   admin_username      = "adminUser"
#   admin_ssh_key {
#     username   = "adminUser"
#     public_key = file("~/.ssh/azure_rsa.pub")
#   }
#   network_interface_ids = [
#     azurerm_network_interface.virtualNIMain.id
#   ]
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   os_disk {
#     storage_account_type = "Standard_LRS"
#     caching              = "ReadWrite"
#   }
# }

# Task 3: creating App service
resource "azurerm_service_plan" "DEVServicePlan" {
  name                = "DEV-ServicePlan-Docker"
  location            = azurerm_resource_group.taskRG.location
  resource_group_name = azurerm_resource_group.taskRG.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "WebApi" {
  name                = "DEV-WebAPi-Docker"
  location            = azurerm_resource_group.taskRG.location
  resource_group_name = azurerm_resource_group.taskRG.name
  service_plan_id     = azurerm_service_plan.DEVServicePlan.id
  #   app_settings = {
  #     "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = false
  #   }
  site_config {
    # application_stack {
    #   docker_image     = "foloo12/backend"
    #   docker_image_tag = "145"
    #   #docker_registry_url = "https://index.docker.io"
    # }
  }
}
