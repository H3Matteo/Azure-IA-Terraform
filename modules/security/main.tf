resource "azurerm_key_vault" "kv" {
  name                        = "kv-ocr-${var.env}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
}

resource "azurerm_role_assignment" "function_storage_access" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.function_principal_id
}

resource "azurerm_role_assignment" "function_vision_access" {
  scope                = var.cognitive_account_id
  role_definition_name = "Cognitive Services User"
  principal_id         = var.function_principal_id
}

resource "azurerm_role_assignment" "function_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.function_principal_id
}