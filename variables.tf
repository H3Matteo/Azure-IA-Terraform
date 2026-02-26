variable "subscription_id" {
  description = "L'ID de la souscription Azure"
  type        = string
}

variable "location" {
  description = "La région Azure pour toutes les ressources"
  type        = string
  default     = "italynorth"
}

variable "project_name" {
  description = "Le nom du projet"
  type        = string
  default     = "ocr"
}

variable "storage_account_name" {}
variable "storage_account_key" {}
variable "storage_account_url" {}
variable "storage_account_id" {}
variable "vision_endpoint" {}
variable "cognitive_account_id" {}
variable "app_insights_key" {}
variable "tenant_id" {}