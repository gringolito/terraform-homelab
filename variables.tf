variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "ssh_private_key_path" {
  type = string
}

variable "ssh_public_keys" {
  type = string
}

variable "deb11_vms" {
  description = "Debian 11 (Bullseye) VMs"
  default     = {}
  type        = map(object({
    description = optional(string)
    vcpus = optional(number)
    memory = optional(number)
    ip = string
    extra_tags = optional(list(string))
  }))
}

variable "deb12_vms" {
  description = "Debian 12 (Bookworm) VMs"
  default     = {}
  type        = map(object({
    description = optional(string)
    vcpus = optional(number)
    memory = optional(number)
    ip = string
    extra_tags = optional(list(string))
  }))
}

variable "el8_vms" {
  description = "EL8-compatible VMs"
  default     = {}
  type        = map(object({
    description = optional(string)
    vcpus = optional(number)
    memory = optional(number)
    ip = string
    extra_tags = optional(list(string))
  }))
}

variable "el9_vms" {
  description = "EL9-compatible VMs"
  default     = {}
  type        = map(object({
    description = optional(string)
    vcpus = optional(number)
    memory = optional(number)
    ip = string
    extra_tags = optional(list(string))
  }))
}

variable "ubuntu22_vms" {
  description = "Ubuntu 22.04 (Jammy) VMs"
  default     = {}
  type        = map(object({
    description = optional(string)
    vcpus = optional(number)
    memory = optional(number)
    ip = string
    extra_tags = optional(list(string))
  }))
}

variable "ubuntu24_vms" {
  description = "Ubuntu 24.04 (Noble) VMs"
  default     = {}
  type        = map(object({
    description = optional(string)
    vcpus = optional(number)
    memory = optional(number)
    ip = string
    extra_tags = optional(list(string))
  }))
}
