data "github_repository_file" "dns_config" {
  count      = var.dns_config_file_method == "github" ? 1 : 0
  repository = var.dns_config_github_repository
  branch     = "master"
  file       = var.dns_config_file

  lifecycle {
    postcondition {
      condition = self.content != null
      error_message = "Failed to fetch '${var.dns_config_file}' from GitHub repository '${var.dns_config_github_repository}'. Please check your GITHUB_TOKEN or the gh cli configuration."
    }
  }
}

data "http" "dns_config" {
  count = var.dns_config_file_method == "http" ? 1 : 0
  url   = var.dns_config_file_url

  request_headers = {
    Accept = "application/yaml"
  }

  lifecycle {
    postcondition {
      condition = self.response_body != null
      error_message = "Failed to fetch '${var.dns_config_file_url}'."
    }
  }
}
