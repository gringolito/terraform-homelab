terraform {
  required_version = ">= 1.9.0"

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }

    dnsmasq = {
      source = "gringolito/dnsmasq"
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
}

provider "dnsmasq" {
  api_url = var.dnsmasq_api_url
}
