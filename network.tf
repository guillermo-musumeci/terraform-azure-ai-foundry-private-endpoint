#########################
## Network - Resources ##
#########################

## Create the Resource Group ##
resource "azurerm_resource_group" "this" {
  name     = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

## Create the VNET ##
resource "azurerm_virtual_network" "this" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

## Create the Subnet for the Application ##
resource "azurerm_subnet" "app" {
  name                 = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-app-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.app_subnet_address_space]

  private_endpoint_network_policies = "Disabled"

  service_endpoints = ["Microsoft.CognitiveServices"]
}

## Create the Subnet for Private Endpoint ##
resource "azurerm_subnet" "pe" {
  name                 = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-pe-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.pe_subnet_address_space]

  private_endpoint_network_policies = "Enabled"

  service_endpoints = ["Microsoft.CognitiveServices"]
}

# Create NSG
resource "azurerm_network_security_group" "nsg" {
  name                = "${lower(replace(var.company," ","-"))}-${var.app_name}-${var.environment}-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  tags     = var.tags
}

# Attach NSG to Application Subnet
resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Attach NSG to Private Endpoint Subnet
resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#########################
## Network - Variables ##
#########################

variable "vnet_address_space" {
  type        = string
  description = "VNET CIDR Block"
}

variable "app_subnet_address_space" {
  type        = string
  description = "Application Subnet CIDR"
}

variable "pe_subnet_address_space" {
  type        = string
  description = "Private Endpoint Subnet CIDR"
}