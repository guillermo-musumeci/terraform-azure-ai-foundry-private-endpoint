# Deploying an Azure AI Foundry with Private Endpoint using Terraform
[![Terraform](https://img.shields.io/badge/terraform-v1.13+-blue.svg)](https://www.terraform.io/downloads.html)

## Overview

Deploying an Azure AI Foundry with Private Endpoint using Terraform

Blog --> https://gmusumeci.medium.com/how-to-deploy-an-azure-ai-foundry-with-private-endpoint-using-terraform-4a9cd55ee266

## Code creates:

- Resource Group
- VNET and Subnet
- Private DNS Zones
- Private DNS Zone Virtual Network Link
- Azure AI Foundry with Private Endpoints
- Azure AI Foundry Project
- Azure AI Foundry Deployments

##  Variables

List of variables used in this code to configure the PostgreSQL Flexible Server:

| Variable | Description | Type | 
| --- | --- | --- | 
| `location` | The region in which this module should be deployed | string | 
| `company` | This variable defines the company name used to build resources | string | 
| `app_name` | This variable defines the application name used to build resources | string | 
| `environment` | This variable defines the environment to be built | string |
| `tags` | The collection of tags to be applied to all resources | map(string) |
| vnet_address_space | VNET CIDR block used for the virtual network | string |
| app_subnet_address_space | CIDR block for the application subnet | string |
| pe_subnet_address_space | CIDR block for the private endpoint subnet | string |
| private_dns_resource_group | Resource group where Private DNS zones are located | string |
| foundry_cognitive_deployment | List of AI Foundry model deployments to create | list(object) |
| foundry_custom_subdomain_name | Custom subdomain name for the AI Foundry Cognitive Account | string |
| foundry_custom_project_name | Name of the AI Foundry project | string |
| foundry_cognitive_account_sku_name | SKU name for the Cognitive Services account | string |
| foundry_dynamic_throttling_enabled | Enables dynamic throttling for the Cognitive Services Account | bool |
| foundry_public_network_access_enabled | Enables or disables public network access | bool |
| foundry_outbound_network_access_restricted | Restricts outbound network access from the Cognitive Services Account | bool |
| foundry_network_acls_default_action | Default action when no network ACL rules match (Allow or Deny) | string |
| foundry_network_acls_ip_rules | List of IP addresses or CIDR blocks allowed to access the Cognitive Services Account | list(string) |

## Private DNS Zone

Private DNS zones are required; use the code below to create them:

```# Create the Resource Group for DNS Zones
resource "azurerm_resource_group" "dns_zone" {
  name     = var.private_dns_resource_group
  location = var.location
}

# Create Private DNS Zone for AI Foundry
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

# Resource Group Variable for Private DNS Zones
variable "private_dns_resource_group" {
  type        = string
  description = "Resource Group for Private DNS Zones"
  default     = "kopicloud-dns-rg"
}

```

## How to deploy the code:

- Clone the repo
- Update **terraform.tfvars** variables to match your environment
- Execute "terraform init"
- Execute "terraform apply"
