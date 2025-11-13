variable "bind9_key_secret" {
  type      = string
  sensitive = true
}

variable "dns_config_file_method" {
  type    = string
  default = "github"
  validation {
    condition     = contains(["github", "http", "local-file"], var.dns_config_file_method)
    error_message = "Valid values for dns_config_file_method are 'github', 'http', or 'local-file'."
  }
}

variable "dns_config_file" {
  description = "Path to the YAML file containing the DNS configuration, should he a full-path for local files or relative path to the repository root for Git files."
  type        = string
  default     = "networking/dns-config.yaml"
}

variable "dns_config_github_repository" {
  type    = string
  default = "gringolito/homelab-configs"
}

variable "dns_config_file_url" {
  type    = string
  default = ""
  validation {
    condition     = var.dns_config_file_method != "http" || length(var.dns_config_file_url) > 0
    error_message = "dns_config_file_url is required when dns_config_file_method is set to 'http'"
  }
}
