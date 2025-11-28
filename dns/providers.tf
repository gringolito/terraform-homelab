terraform {
  required_version = ">= 1.13.0"

  required_providers {
    dns = {
      source = "hashicorp/dns"
    }

    ansible = {
      source = "ansible/ansible"
    }
  }
}

provider "dns" {
  update {
    server        = var.nameserver_address
    key_name      = var.tsig_key_name
    key_algorithm = var.tsig_key_algorithm
    key_secret    = var.tsig_key_secret
  }
}
