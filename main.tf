resource "azurerm_firewall_nat_rule_collection" "nat_rules" {
  for_each = { for k, v in var.nat_rule_collections : k => v }

  name                = each.value.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.rg_name
  priority            = each.value.priority
  action              = title(each.value.action)

  dynamic "rule" {
    for_each = each.value.rules
    content {
      name                  = rule.value.name
      protocols             = upper(rule.value.protocols)
      description           = rule.value.description
      source_addresses      = rule.value.source_addresses
      source_ip_groups      = rule.value.source_ip_groups
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      translated_address    = rule.value.translated_address
      translated_fqdn       = rule.value.translated_fqdn
      translated_port       = rule.value.translated_ports
    }
  }
}
