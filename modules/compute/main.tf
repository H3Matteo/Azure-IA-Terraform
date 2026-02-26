resource "azurerm_service_plan" "function_plan" {
  name                = "func-plan-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "function_app" {
  name                       = "func-ocr-${var.env}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.function_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_key

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_insights_key = var.app_insights_key
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    VISION_ENDPOINT          = var.vision_endpoint
    STORAGE_ACCOUNT_URL      = var.storage_account_url
  }
}