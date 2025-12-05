terraform {
  required_version = ">= 1.13.0"

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }

    ansible = {
      source = "ansible/ansible"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token

  ssh {
    agent    = true
    username = "root"
  }

  random_vm_ids      = true
  random_vm_id_end   = 299
  random_vm_id_start = 200
}
