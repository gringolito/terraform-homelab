terraform {
  required_version = ">= 0.14"

  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
  }
}
