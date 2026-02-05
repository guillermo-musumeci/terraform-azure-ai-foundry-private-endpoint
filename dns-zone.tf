##################################
## Private DNS Zone - Resources ##
##################################

## Create the Resource Group for DNS Zones ##
resource "azurerm_resource_group" "dns_zone" {
  name     = var.private_dns_resource_group
  location = var.location
  tags     = {
    "Application Name" = "Private DNS Zones"
    "Environment"      = "Dev"
  }
}

## Create Private DNS Zone for AI Foundry ##
resource "azurerm_private_dns_zone" "foundry" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = azurerm_resource_group.dns_zone.name
}

# Create Private DNS Zone for AI Foundry
resource "azurerm_private_dns_zone" "openai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.dns_zone.name
}

# Create Private DNS Zone for AI Foundry
resource "azurerm_private_dns_zone" "services_ai" {
  name                = "privatelink.services.ai.azure.com"
  resource_group_name = azurerm_resource_group.dns_zone.name
}

##################################
## Private DNS Zone - Variables ##
##################################

variable "private_dns_resource_group" {
  type        = string
  description = "Resource Group for Private DNS Zones"
  default     = "kopicloud-dns-rg"
}