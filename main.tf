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

module "monitoring" {
  source = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  project_name        = var.project_name
  env                 = terraform.workspace
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  env                 = terraform.workspace

  storage_account_name = module.storage.storage_account_name
  storage_account_key  = module.storage.primary_access_key
  storage_account_url  = module.storage.primary_blob_endpoint

  vision_endpoint      = module.cognitive_service.endpoint
  app_insights_key     = module.monitoring.instrumentation_key
}

module "security" {
  source = "./modules/security"

  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  env                   = terraform.workspace
  tenant_id             = var.tenant_id

  function_principal_id = module.compute.function_principal_id

  storage_account_id    = module.storage.storage_account_id
  cognitive_account_id  = module.cognitive_service.cognitive_account_id

  app_insights_key      = module.monitoring.instrumentation_key
}