terraform {
  required_version = ">= 1.13.0"

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }

    ansible = {
      source  = "ansible/ansible"
    }
  }
}
