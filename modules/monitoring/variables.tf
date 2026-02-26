variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Localisation des ressources"
  type        = string
}

variable "env" {
  description = "Environnement (dev ou prod)"
  type        = string
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
}