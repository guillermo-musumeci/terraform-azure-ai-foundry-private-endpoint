###############################
## Azure AI Foundry - Output ##
###############################

output "ai_foundry_name" {
  value = azurerm_cognitive_account.foundry.name
}

output "ai_foundry_endpoint" {
  value = azurerm_cognitive_account.foundry.endpoint
}

output "ai_foundry_project" {
  value = azurerm_cognitive_account_project.foundry.name
}

// use this only in dev phase
output "ai_foundry_access_key" {
  value = nonsensitive(azurerm_cognitive_account.foundry.primary_access_key)
}
