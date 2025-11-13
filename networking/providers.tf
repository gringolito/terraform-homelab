terraform {
  required_version = ">= 1.9.0"

  required_providers {
    dns = {
      source = "hashicorp/dns"
    }

    github = {
      source  = "integrations/github"
    }
  }
}

provider "dns" {
  update {
    server        = "192.168.11.10"
    key_name      = "terraform-homelab."
    key_algorithm = "hmac-sha256"
    key_secret    = var.bind9_key_secret
  }
}

provider "github" {}
