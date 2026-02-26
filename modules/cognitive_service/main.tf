resource "azurerm_cognitive_account" "vision" {
  name                = "cog-${var.project_name}-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "ComputerVision"

  sku_name            = "S1"

  public_network_access_enabled = true
}