resource "dns_cname_record" "cname" {
  for_each = local.dns_cname_records

  zone  = each.value.zone_fqdn
  name  = each.value.name
  cname = each.value.cname
  ttl   = each.value.ttl
}

resource "dns_a_record_set" "a" {
  for_each = local.dns_a_records

  zone      = each.value.zone_fqdn
  name      = each.value.name
  addresses = each.value.addresses
  ttl       = each.value.ttl
}

resource "dns_ptr_record" "ptr" {
  for_each = local.dns_ptr_records

  zone = each.value.zone_fqdn
  name = each.value.name
  ptr  = each.value.ptr
  ttl  = each.value.ttl
}
