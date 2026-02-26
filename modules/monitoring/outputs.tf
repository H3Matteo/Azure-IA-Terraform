output "instrumentation_key" {
  description = "La clé d'instrumentation d'App Insights"
  value       = azurerm_application_insights.appinsights.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "La chaîne de connexion d'App Insights"
  value       = azurerm_application_insights.appinsights.connection_string
  sensitive   = true
}