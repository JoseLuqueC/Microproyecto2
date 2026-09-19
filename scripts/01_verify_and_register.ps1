# 01_verify_and_register.ps1
# Script para registrar proveedores y verificar regiones en Azure

$subscriptionId = "c7fc4381-3a81-4d53-8d8d-c69a2fafe363"
Write-Host "Configurando suscripción: $subscriptionId" -ForegroundColor Cyan
az account set --subscription $subscriptionId

Write-Host "Registrando proveedores de recursos indispensables para AKS..." -ForegroundColor Cyan
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights

Write-Host "Validando estado de registro de Microsoft.ContainerService..." -ForegroundColor Yellow
az provider show -n Microsoft.ContainerService --query "registrationState" -o tsv

Write-Host "Verificando regiones permitidas por política..." -ForegroundColor Cyan
az policy assignment show --name sys.regionrestriction --scope "/subscriptions/$subscriptionId" --query "parameters.listOfAllowedLocations.value" -o tsv
