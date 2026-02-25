terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.1.0"
        }
    }
}

provider "azurerm" {
    resource_provider_registrations = "none"
        features {}
    subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
    name     = "rg-${var.project_name}-${terraform.workspace}"
    location = var.location
}

module "network" {
    source = "./modules/network"

    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    project_name        = var.project_name
    env                 = terraform.workspace
}

module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  env                 = terraform.workspace
}

module "cognitive_service" {
  source = "./modules/cognitive_service"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  env                 = terraform.workspace
}