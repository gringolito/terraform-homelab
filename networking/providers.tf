terraform {
  required_version = ">= 1.13.0"

  required_providers {
    incus = {
      source = "lxc/incus"
    }

    cloudinit = {
      source = "hashicorp/cloudinit"
    }

    ansible = {
      source = "ansible/ansible"
    }
  }
}
