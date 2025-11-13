locals {
  _dns_config_sources = {
    github     = try(data.github_repository_file.dns_config[0].content, "")
    http       = try(data.http.dns_config[0].response_body, "")
    local-file = try(file(var.dns_config_file), "")
  }
  _dns_yaml_file = local._dns_config_sources[var.dns_config_file_method]
  _dns_config    = yamldecode(local._dns_yaml_file)
  _dns_zones_map = lookup(local._dns_config, "zones", {})
  tld            = local._dns_config.tld

  # Flatten CNAMEs into a list of objects
  _dns_cname_list = flatten([
    for zone_name, zone in local._dns_zones_map : [
      for cname_name, cname_target in lookup(zone.records, "cname", {}) :
      {
        id        = "${cname_name}.${zone_name}.${local.tld}"
        zone_fqdn = "${zone_name}.${local.tld}."
        name      = cname_name
        cname     = "${cname_target}."
        ttl       = lookup(lookup(zone, "ttl", {}), "cname", 3600)
      }
    ]
  ])

  dns_cname_records = { for r in local._dns_cname_list : r.id => r }

  # Flatten A records (each A record keeps the whole addresses list)
  _dns_a_list = flatten([
    for zone_name, zone in local._dns_zones_map : [
      for a_name, addrs in lookup(zone.records, "a", {}) :
      {
        id        = "${a_name}.${zone_name}.${local.tld}"
        zone_fqdn = "${zone_name}.${local.tld}."
        name      = a_name
        addresses = addrs
        ttl       = lookup(lookup(zone, "ttl", {}), "a", 300)
      }
    ]
  ])

  dns_a_records = { for r in local._dns_a_list : r.id => r }

  # Build PTR records: one PTR per IP address
  _dns_ptr_list = flatten([
    for zone_name, zone in local._dns_zones_map : [
      for a_name, addrs in lookup(zone.records, "a", {}) : [
        for ip in addrs : {
          id        = "${ip}"
          zone_fqdn = "${lookup(zone, "reverse-zone", "")}.in-addr.arpa."
          name      = element(split(".", ip), length(split(".", ip)) - 1) # last octet of IPv4
          ptr       = "${a_name}.${zone_name}.${local.tld}."
          ttl       = lookup(lookup(zone, "ttl", {}), "a", 300)
        }
      ]
    ]
  ])

  dns_ptr_records = { for r in local._dns_ptr_list : r.id => r }
}

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

