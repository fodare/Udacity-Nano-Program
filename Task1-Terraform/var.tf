variable "vm-count" {
  type        = number
  description = "Count of vm(s) to create"
  default     = 1
}

variable "vm-username" {
  type        = string
  description = "Vm user name"
  default     = "adminUser"
}

variable "nic-count" {
  type        = number
  description = "NIC count."
  default     = 1
}

variable "nsg-count" {
  type        = number
  description = "Network security group count."
  default     = 1
}
