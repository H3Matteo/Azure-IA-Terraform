# Projet : Infrastructure Azure pour Application OCR (Serverless)

Ce projet contient l'infrastructure as code (IaC) Terraform complète pour déployer une solution serverless d'extraction de texte (OCR) sur Microsoft Azure. 

## Description de l'architecture

L'infrastructure est conçue de manière modulaire et s'appuie sur les services suivants :
* **Compute :** Azure Function App (Linux, Serverless Y1) en Python.
* **Stockage :** Azure Blob Storage avec deux conteneurs (`images` en entrée, `results` en sortie).
* **Intelligence Artificielle :** Azure Cognitive Services (Computer Vision) pour l'analyse OCR.
* **Sécurité :** Azure Key Vault pour la gestion des secrets et Managed Identities.
* **Monitoring :** Application Insights et Log Analytics Workspace.
* **Réseau :** Virtual Network (VNet) et Subnet dédiés.

## Choix de Sécurité et d'Architecture

Nous avons appliqué les meilleures pratiques Cloud (Principe du moindre privilège et Zero Trust) :
1. **Identité Managée (Managed Identity) :** La Function App utilise une identité assignée par le système (SystemAssigned). Aucun mot de passe n'est stocké en clair dans le code.
2. **RBAC (Role-Based Access Control) :** L'identité de la fonction possède uniquement les droits stricts dont elle a besoin :
   * `Storage Blob Data Contributor` sur le compte de stockage.
   * `Cognitive Services User` sur le service d'IA.
   * `Key Vault Secrets User` sur le coffre-fort.
3. **Key Vault :** Les secrets de l'infrastructure (ex: clé Application Insights) sont générés dynamiquement et stockés de manière sécurisée dans Azure Key Vault.

## Estimation des coûts (Environnement Dev)

L'architecture a été pensée pour être la plus économique possible (approche FinOps) :
* **Function App (Plan Y1 / Consommation) :** Gratuit pour le premier million d'exécutions mensuelles. Paiement à l'usage uniquement.
* **Cognitive Services (S1) :** Facturation à l'appel d'API (quelques centimes pour 1000 transactions).
* **Storage Account (Standard LRS) :** Coût très faible, facturé au Go stocké (environ 0.02€/Go/mois).
* **Log Analytics & App Insights :** Gratuit jusqu'à 5 Go d'ingestion de logs par mois.
* **Estimation totale :** Moins de 5€/mois en phase de développement/test.

## Comment déployer ?

### Prérequis
* [Terraform](https://www.terraform.io/downloads.html) installé.
* [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli) installé et authentifié (`az login`).

### Déploiement automatisé
Un script Bash est fourni pour automatiser entièrement l'initialisation, la validation et le déploiement sur l'environnement de développement (`dev`).

Exécutez la commande suivante à la racine du projet :
```bash
./deploy.sh
```