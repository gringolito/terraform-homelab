resource "proxmox_virtual_environment_download_file" "pvi" {
  for_each     = local.pvi_images
  content_type = "import"
  datastore_id = var.pvi_storage
  node_name    = var.proxmox_node
  url          = each.value.url
  file_name    = each.value.filename
  overwrite    = true
}
