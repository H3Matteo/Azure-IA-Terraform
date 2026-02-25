resource "azurerm_storage_account" "storage" {
  name                     = "st${var.project_name}${var.env}db" 
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = true
}

resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "results" {
  name                  = "results"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}