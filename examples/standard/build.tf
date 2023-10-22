module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

module "network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-${var.short}-${var.loc}-${var.env}-01"
  vnet_location      = module.rg.rg_location
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "sn1-${module.network.vnet_name}" = {
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
}

module "firewall" {
  source = "cyber-scot/firewall/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  name = "fw-${var.short}-${var.loc}-${var.env}-01"

  create_firewall_subnet               = true
  create_firewall_management_subnet    = true
  create_firewall_management_public_ip = true
  create_firewall_data_public_ip       = true
  vnet_rg_name                         = module.network.vnet_rg_name
  vnet_name                            = module.network.vnet_name

  firewall_subnet_prefixes            = ["10.0.0.0/26"]
  firewall_management_subnet_prefixes = ["10.0.0.64/26"] # Minimum /26

  ip_configuration            = {} # Use module inherited values
  management_ip_configuration = {} # Enables force tunnel mode
}

module "firewall_rules" {
  source = "../../"

  rg_name       = module.rg.rg_name
  firewall_name = module.firewall.firewall_name

  nat_rule_collections = [
    {
      name     = "dnat-rules"
      action   = "Dnat"
      priority = 100
      rules = [
        {
          name                  = "DNAT-HTTP"
          description           = "DNAT rule for HTTP traffic"
          destination_addresses = ["203.0.113.1"]
          destination_ports     = ["80"]
          protocols             = ["TCP"]
          source_addresses      = ["10.0.0.0/16"]
          translated_address    = "192.168.1.1"
          translated_ports      = 8080
        },
        {
          name                  = "DNAT-HTTPS"
          description           = "DNAT rule for HTTPS traffic"
          destination_addresses = ["203.0.113.1"]
          destination_ports     = ["443"]
          protocols             = ["TCP"]
          source_addresses      = ["10.0.0.0/16"]
          translated_address    = "192.168.1.1"
          translated_ports      = 8443
        },
        {
          name                  = "DNAT-DNS"
          description           = "DNAT rule for DNS traffic"
          destination_addresses = ["203.0.113.1"]
          destination_ports     = ["53"]
          protocols             = ["UDP"]
          source_addresses      = ["10.0.0.0/16"]
          translated_address    = "192.168.1.1"
          translated_ports      = 53
        }
      ]
    },
    {
      name     = "snat-rules"
      action   = "Snat"
      priority = 200
      rules = [
        {
          name                  = "SNAT-HTTP"
          description           = "SNAT rule for HTTP traffic"
          destination_addresses = ["0.0.0.0/0"]
          destination_ports     = ["80"]
          protocols             = ["TCP"]
          source_addresses      = ["10.0.0.0/16"]
          translated_address    = "203.0.113.1"
          translated_ports      = 80
        },
        {
          name                  = "SNAT-HTTPS"
          description           = "SNAT rule for HTTPS traffic"
          destination_addresses = ["0.0.0.0/0"]
          destination_ports     = ["443"]
          protocols             = ["TCP"]
          source_addresses      = ["10.0.0.0/16"]
          translated_address    = "203.0.113.1"
          translated_ports      = 443
        },
        {
          name                  = "SNAT-DNS"
          description           = "SNAT rule for DNS traffic"
          destination_addresses = ["0.0.0.0/0"]
          destination_ports     = ["53"]
          protocols             = ["UDP"]
          source_addresses      = ["10.0.0.0/16"]
          translated_address    = "203.0.113.1"
          translated_ports      = 53
        }
      ]
    }
  ]
}




