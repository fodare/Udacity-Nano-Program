output "virtual-machine-name" {
  value = [for i in azurerm_linux_virtual_machine.test-vm : i.name[*]]
}
