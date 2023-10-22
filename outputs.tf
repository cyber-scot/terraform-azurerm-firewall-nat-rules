output "nat_rule_collections_output" {
  description = "The NAT rule collections created by the module."
  value       = azurerm_firewall_nat_rule_collection.nat_rules
}

output "nat_rule_ids" {
  description = "The IDs of the NAT rule collections."
  value       = { for k, v in azurerm_firewall_nat_rule_collection.nat_rules : k => v.id }
}

output "nat_rule_names" {
  description = "The names of the NAT rule collections."
  value       = { for k, v in azurerm_firewall_nat_rule_collection.nat_rules : k => v.name }
}

output "nat_rules" {
  description = "Details of the NAT rules within each collection."
  value       = { for k, v in azurerm_firewall_nat_rule_collection.nat_rules : k => v.rule }
}
