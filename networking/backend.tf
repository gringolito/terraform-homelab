terraform {
  backend "s3" {
    bucket  = "terraform-state"
    key     = "homelab-networking.tfstate"
    region  = "br-home-1"
    profile = "homelab"
    endpoints = {
      s3 = "http://s3.home.gringolito.com:9000"
    }
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
  }
}
