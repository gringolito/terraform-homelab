terraform {
  required_version = ">= 1.9.0"

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }

    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
  }
}
