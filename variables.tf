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