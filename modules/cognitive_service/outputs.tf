output "endpoint" {
  description = "L'URL de l'API Cognitive Service"
  value       = azurerm_cognitive_account.vision.endpoint
}

output "primary_access_key" {
  description = "La clé d'accès principale de l'API"
  value       = azurerm_cognitive_account.vision.primary_access_key
  sensitive   = true
}
output "cognitive_account_id" {
  value = azurerm_cognitive_account.vision.id
}