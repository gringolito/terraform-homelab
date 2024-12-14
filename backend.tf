terraform {
    backend "s3" {
        bucket = "terraform-state"
        endpoints = {
            s3 = "http://s3.home.gringolito.com:9000"
        }
        key = "terraform-homelab.tfstate"
        region = "br-homelab-01"
        skip_credentials_validation = true
        skip_requesting_account_id = true
        skip_metadata_api_check = true
        skip_region_validation = true
        use_path_style = true
    }
}
