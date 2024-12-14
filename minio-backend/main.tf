terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "br-homelab-01"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  s3_use_path_style           = true
  insecure                    = true

  endpoints {
    s3 = "http://s3.home.gringolito.com:9000"
  }
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "terraform-state"

  tags = {
    Name = "Terraform state files"
  }
}
