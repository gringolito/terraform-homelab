variable "name" {
  description = "VM name"
  type        = string
}

variable "description" {
  type = string
}

variable "template" {
  type    = string
  default = "rocky-9-x64-ci-template"
}

variable "vcpus" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 1024
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "nic_model" {
  type    = string
  default = "virtio"
}

variable "ci_username" {
  type    = string
  default = "ansible"
}

variable "ci_password" {
  type      = string
  default   = null
  sensitive = true
  nullable  = true
}

variable "ci_ssh_public_keys" {
  type = string
}

variable "ci_ip" {
  type = string
}

variable "ci_netmask" {
  type    = number
  default = 24
}

variable "ci_gateway" {
  type    = string
  default = "192.168.11.1"
}

variable "ci_dns_server" {
  type    = string
  default = "192.168.11.53"
}

variable "ci_domain" {
  type    = string
  default = "home"
}

variable "ci_wait" {
  type    = number
  default = 30
}

variable "ssh_private_key_path" {
  type      = string
}

variable "ansible_groups" {
  type    = list(string)
  default = []
}

variable "ansible_custom_vars" {
  type    = map(any)
  default = {}
}
