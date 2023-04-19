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

variable "el7_vms" {
  description = "EL7-compatible VMs"
  default     = {}
  type        = map(any)
}

variable "el9_vms" {
  description = "EL9-compatible VMs"
  default     = {}
  type        = map(any)
}
