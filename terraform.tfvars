####################
# Common Variables #
####################
company     = "kopicloud"
app_name    = "aitest"
environment = "dev"
location    = "swedencentral"
tags        = {
  "Application Name" = "AI Test"
  "Environment"      = "Dev"
}

##################
# Authentication #
##################
azure_subscription_id = "complete-this"
azure_client_id       = "complete-this"
azure_client_secret   = "complete-this"
azure_tenant_id       = "complete-this"

###########
# Network #
###########
vnet_address_space       = "10.120.0.0/16"
app_subnet_address_space = "10.120.1.0/24"
pe_subnet_address_space  = "10.120.2.0/24"

##############
# AI Foundry #
##############
foundry_custom_subdomain_name = "kopicloud-foundry"
foundry_custom_project_name   = "kopicloud-project"
foundry_cognitive_account_sku_name  = "S0"
foundry_network_acls_default_action = "Deny"
foundry_network_acls_ip_rules       = []
foundry_dynamic_throttling_enabled         = false
foundry_public_network_access_enabled      = false
foundry_outbound_network_access_restricted = false

foundry_cognitive_deployment = [
  {
    name       = "gpt-5"
    format     = "OpenAI"
    type       = "gpt-5"
    version    = "2025-08-07"
    scale_type = "GlobalStandard"
    capacity   = 10
  },
  {
    name       = "gpt-4o"
    format     = "OpenAI"
    type       = "gpt-4o"
    version    = "2024-11-20"
    scale_type = "GlobalStandard"
    capacity   = 10
  } 
]
