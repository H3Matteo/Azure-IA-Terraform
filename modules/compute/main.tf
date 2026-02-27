resource "azurerm_service_plan" "function_plan" {
  name                = "func-plan-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
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
  application_stack {
    python_version = "3.10"
  }
}

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME  = "python"
    FUNCTIONS_EXTENSION_VERSION = "~4"
    AzureWebJobsStorage = "DefaultEndpointsProtocol=https;AccountName=${var.storage_account_name};AccountKey=${var.storage_account_key};EndpointSuffix=core.windows.net"
  }
}