terraform {
  required_version = ">= 0.14"

  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "~> 2.9.14"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.0.0"
    }
  }
}
