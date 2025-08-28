variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "dnsmasq_api_url" {
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
    description = optional(string)
    pvi         = string
    vcpus       = optional(number)
    memory      = optional(number)
    network     = optional(string)
    disk_size   = optional(number)
    tags        = optional(list(string))
    power_on    = optional(bool)
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

variable "pvi_images" {
  description = "Proxmox VM Images (PVI)"
  default     = {}
  type = map(object({
    url      = string
    filename = string
    ci-type  = string
  }))
}

variable "pvi_storage" {
  type    = string
  default = "truenas-nfs"
}
