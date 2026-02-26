output "storage_account_name" {
  description = "Le nom du compte de stockage"
  value       = azurerm_storage_account.storage.name
}

output "primary_access_key" {
  description = "La clé d'accès primaire"
  value       = azurerm_storage_account.storage.primary_access_key
  sensitive   = true
}

output "images_container_name" {
  description = "Le nom du conteneur d'images"
  value       = azurerm_storage_container.images.name
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}
output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}