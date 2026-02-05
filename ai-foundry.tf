##################################
## Azure AI Foundry - Resources ##
##################################

## Create Azure Cognitive Services Account for AI Foundry ##
resource "azurerm_cognitive_account" "foundry" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-foundry"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku_name            = var.foundry_cognitive_account_sku_name

  public_network_access_enabled      = var.foundry_public_network_access_enabled
  outbound_network_access_restricted = var.foundry_outbound_network_access_restricted
  dynamic_throttling_enabled         = var.foundry_dynamic_throttling_enabled

  // Foundry Settings
  kind                       = "AIServices"  
  project_management_enabled = true

  custom_subdomain_name = var.foundry_custom_subdomain_name != "" ? var.foundry_custom_subdomain_name : "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-foundry"

  identity {
    type = "SystemAssigned"
  }

  network_acls {
    bypass         = "AzureServices" 
    default_action = "Deny"
    ip_rules       = var.foundry_network_acls_ip_rules
    virtual_network_rules {
      subnet_id = azurerm_subnet.app.id
    }
    virtual_network_rules {
      subnet_id = azurerm_subnet.pe.id
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_resource_group.this,
    azurerm_virtual_network.this,
    azurerm_subnet.app,
    azurerm_subnet.pe
  ]
}

## Create the Azure Cognitive Deployment ##
resource "azurerm_cognitive_deployment" "foundry" {
  for_each = {
    for key, value in var.foundry_cognitive_deployment :
    key => value
  }

  name = "${var.app_name}-${each.value.name}"
  
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  model {
    format  = each.value.format
    name    = each.value.type
    version = each.value.version
  }

  sku {
    name = each.value.scale_type
    capacity = each.value.capacity
  }

  depends_on = [
    azurerm_resource_group.this,
    azurerm_cognitive_account.foundry
  ]
}

## Create AI Foundry Project ##
resource "azurerm_cognitive_account_project" "foundry" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-project"
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = azurerm_resource_group.this.location
  description          = "Foundry project for ${var.app_name}"
  
  display_name = var.foundry_custom_project_name != "" ? var.foundry_custom_project_name : "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-project"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

##################################
## Azure AI Foundry - Variables ##
##################################

variable "foundry_cognitive_deployment" {
  description = "List of AI Foundry Deployments"
  type = list(object({
    name       = string
    format     = string
    type       = string
    version    = string
    scale_type = string
    capacity   = number
  }))
  default = []
}

variable "foundry_custom_subdomain_name" {
  type        = string
  description = "Specifies the Custom Domain for the AI Foundry"
  default     = ""
}

variable "foundry_custom_project_name" {
  type        = string
  description = "Specifies the AI Foundry Project Name"
  default     = ""
}

variable "foundry_cognitive_account_sku_name" {
  type        = string
  description = "Specifies the SKU Name for thie Cognitive Service Account"
  default     = "S0"
}

variable "foundry_dynamic_throttling_enabled" {
  type        = bool
  description = "Specifies whether dynamic throttling is enabled for this Cognitive Service Account"
  default     = false
}

variable "foundry_public_network_access_enabled" {
  type        = bool
  description = "Enable public network access"
  default     = false
}

variable "foundry_outbound_network_access_restricted" {
  type        = bool
  description = "Whether outbound network access is restricted for the Cognitive Service Account"
  default     = false
}

variable "foundry_network_acls_default_action" {
  type        = string
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_rules. Possible values are Allow and Deny"
  default     = "Deny"
}

variable "foundry_network_acls_ip_rules" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks, which should be able to access the Cognitive Service Account"
  default     = []
}