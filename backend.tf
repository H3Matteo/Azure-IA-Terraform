terraform {
  backend "azurerm" {
    resource_group_name  = "rg-ia-tfstate"
    storage_account_name = "sttfstateocr999"
    container_name       = "tfstate"
    key                  = "projet-ia.tfstate"
  }
}