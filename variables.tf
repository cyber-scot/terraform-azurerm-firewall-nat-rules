variable "firewall_name" {
  type        = string
  description = "The name of the Azure firewall this rule collection should be added to"
}

variable "nat_rule_collections" {
  description = "A list of NAT rule collections, each containing a list of NAT rules."
  type = list(object({
    name     = string
    action   = string
    priority = number
    rules = list(object({
      name                  = string
      description           = optional(string)
      destination_addresses = list(string)
      destination_ports     = list(string)
      protocols             = list(string)
      source_addresses      = optional(list(string))
      source_ip_groups      = optional(list(string))
      translated_address    = optional(string)
      translated_fqdn       = optional(string)
      translated_ports      = number
    }))
  }))
  default = []
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group the Azure firewall resides within"
}
