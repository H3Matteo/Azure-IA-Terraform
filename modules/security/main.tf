data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "kv-ocrdb-dev-99"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true

  enable_rbac_authorization   = true 
}

resource "azurerm_role_assignment" "function_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.function_principal_id
}

resource "azurerm_role_assignment" "terraform_kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "app_insights_secret" {
  name         = "app-insights-key"
  value        = var.app_insights_key
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_role_assignment.terraform_kv_access
  ]
}