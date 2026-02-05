## Create Private DNS Zone Virtual Network Link for AI Foundry ## 
resource "azurerm_private_dns_zone_virtual_network_link" "foundry" {
  name                  = "${azurerm_cognitive_account.foundry.name}-vlink"
  resource_group_name   = var.private_dns_resource_group
  private_dns_zone_name = azurerm_private_dns_zone.foundry.name
  virtual_network_id    = azurerm_virtual_network.this.id

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [
    azurerm_resource_group.this,
    azurerm_virtual_network.this,
    azurerm_cognitive_account.foundry
  ]
}

## Create the Private Endpoint for AI Foundry ##
resource "azurerm_private_endpoint" "foundry" {
  name                  = "${azurerm_cognitive_account.foundry.name}-pe"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${azurerm_cognitive_account.foundry.name}-psc"
    private_connection_resource_id = azurerm_cognitive_account.foundry.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.foundry.id,
      azurerm_private_dns_zone.openai.id,
      azurerm_private_dns_zone.services_ai.id
    ]
  }

  tags = var.tags

  depends_on = [
    azurerm_resource_group.this,
    azurerm_subnet.pe,
    azurerm_cognitive_account.foundry
  ]
}