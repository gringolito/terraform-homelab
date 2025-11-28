variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "ssh_private_key_path" {
  type = string
}

variable "ssh_public_keys" {
  type = string
}

variable "vms" {
  description = "Cloud-Init VMs"
  default     = {}
  type = map(object({
    description     = optional(string, "")
    pvi             = string
    vcpus           = optional(number, 1)
    memory          = optional(number, 512)
    networks        = optional(list(string), ["Dev"])
    disk_size       = optional(number, 10)
    tags            = optional(list(string), [])
    power_on        = optional(bool, true)
    gpu_passthrough = optional(bool, false)
    provision       = optional(bool, true)
  }))
}

variable "appliances" {
  description = "Appliances or manually created/imported VMs"
  default     = {}
  type = map(object({
    vcpus           = optional(number, 1)
    memory          = optional(number, 512)
    networks        = optional(list(string), ["Dev"])
    disks           = optional(list(number), [10])
    disk_interface  = optional(string, "virtio")
    power_on        = optional(bool, true)
    gpu_passthrough = optional(bool, false)
    efi             = optional(bool, false)
  }))
}

variable "desktops" {
  description = "Desktops VMs"
  default     = {}
  type = map(object({
    vcpus           = optional(number, 1)
    memory          = optional(number, 512)
    networks        = optional(list(string), ["vmbr0"])
    disks           = optional(list(number), [10])
    disk_interface  = optional(string, "virtio")
    power_on        = optional(bool, false)
    gpu_passthrough = optional(bool, false)
    efi             = optional(bool, true)
    os              = optional(string, "l26")
  }))
}

variable "vm_storage" {
  type    = string
  default = "truenas-vm-disks"
}

variable "cloudinit_storage" {
  type    = string
  default = "truenas-nfs"
}

variable "pvi_storage" {
  type    = string
  default = "truenas-nfs"
}

variable "vault_password_file" {
  type = string
}
