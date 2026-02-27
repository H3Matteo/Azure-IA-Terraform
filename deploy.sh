#!/bin/bash

# Arrête le script immédiatement si une commande échoue
set -e

echo "Initialisation de Terraform..."
terraform init

echo "Validation du code..."
terraform validate

echo "Sélection de l'environnement dev..."
terraform workspace select dev || terraform workspace new dev

echo "Déploiement de l'infrastructure..."
terraform apply -auto-approve