
```hcl
resource "azurerm_firewall_nat_rule_collection" "nat_rules" {
  for_each = { for k, v in var.nat_rule_collections : k => v }

  name                = each.value.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.rg_name
  priority            = each.value.priority
  action              = title(each.value.action)

  dynamic "rule" {
    for_each = each.value.rules != null ? [each.value.rules] : []
    content {
      name                  = rule.value.name
      protocols             = rule.value.protocols
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_ports
    }
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_nat_rule_collection.nat_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | The name of the Azure firewall this rule collection should be added to | `string` | n/a | yes |
| <a name="input_nat_rule_collections"></a> [nat\_rule\_collections](#input\_nat\_rule\_collections) | A list of NAT rule collections, each containing a list of NAT rules. | <pre>list(object({<br>    name     = string<br>    action   = string<br>    priority = number<br>    rules = list(object({<br>      name                  = string<br>      description           = optional(string)<br>      destination_addresses = list(string)<br>      destination_ports     = list(string)<br>      protocols             = list(string)<br>      source_addresses      = optional(list(string))<br>      source_ip_groups      = optional(list(string))<br>      translated_address    = optional(string)<br>      translated_fqdn       = optional(string)<br>      translated_ports      = number<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group the Azure firewall resides within | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_rule_collections_output"></a> [nat\_rule\_collections\_output](#output\_nat\_rule\_collections\_output) | The NAT rule collections created by the module. |
| <a name="output_nat_rule_ids"></a> [nat\_rule\_ids](#output\_nat\_rule\_ids) | The IDs of the NAT rule collections. |
| <a name="output_nat_rule_names"></a> [nat\_rule\_names](#output\_nat\_rule\_names) | The names of the NAT rule collections. |
| <a name="output_nat_rules"></a> [nat\_rules](#output\_nat\_rules) | Details of the NAT rules within each collection. |
