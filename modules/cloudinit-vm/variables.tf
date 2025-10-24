variable "name" {
  description = "VM hostname"
  type        = string
}

variable "description" {
  description = "Human-readable description to be added on the VM metadata"
  type        = string
}

variable "tags" {
  description = "List of tags to be added on the VM"
  type        = list(string)
  default     = []
}

variable "pvi_id" {
  description = "The Proxmox VM Image (PVI) ID to create the VM from"
  type        = string
}

variable "vcpus" {
  description = "The number of CPU cores to be assigned to the VM"
  type        = number
  default     = 1
}

variable "memory" {
  description = "The VM RAM memory size in MB"
  type        = number
  default     = 1024
}

variable "disk_size" {
  description = "The VM disk size in GB"
  type        = number
  default     = 10
}

variable "disk_storage" {
  type = string
}

variable "pve_node" {
  description = "Proxmox node to assign the VM to"
  type        = string
}

variable "scsi_controller" {
  type    = string
  default = "virtio-scsi-pci"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "nic_model" {
  type    = string
  default = "virtio"
}

variable "ci_storage" {
  type = string
}

variable "ci_username" {
  type    = string
  default = "ansible"
}

variable "ci_ssh_public_keys" {
  type = string
}

variable "ci_dns_server" {
  type    = string
  default = "192.168.11.53"
}

variable "ci_domain" {
  type    = string
  default = "home.gringolito.com"
}

variable "ci_type" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "power_on" {
  type    = bool
  default = true
}

variable "extra_networks" {
  type    = list(string)
  default = []
}
