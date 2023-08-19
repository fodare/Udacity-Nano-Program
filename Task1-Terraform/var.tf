variable "vm-count" {
  type        = number
  description = "Count of vm(s) to create"
}

variable "vm-username" {
  type        = string
  description = "Vm user name"
  default     = "adminUser"
}

variable "nic-count" {
  type        = number
  description = "NIC count."
}

variable "nsg-count" {
  type        = number
  description = "Network security group count."
}
