#!/usr/bin/env bash
# cloudshell_workflow.sh
# Flujo completo automatizado para Azure Cloud Shell

SUBSCRIPTION_ID="c7fc4381-3a81-4d53-8d8d-c69a2fafe363"
RG="rg-microproyecto2"
LOCATION="westus"
CLUSTER_NAME="aks-microproyecto2"

echo "=== 1. Configurando Suscripción ==="
az account set --subscription "$SUBSCRIPTION_ID"

echo "=== 2. Registrando Proveedores de Recursos ==="
az provider register --namespace Microsoft.Compute
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace microsoft.insights

echo "=== 3. Creando Grupo de Recursos ==="
az group create --name "$RG" --location "$LOCATION"

echo "=== 4. Creando Clúster AKS Económico (2 nodos standard_b2ps_v2 ARM64) ==="
az aks create \
  --resource-group "$RG" \
  --name "$CLUSTER_NAME" \
  --node-count 2 \
  --node-vm-size standard_b2ps_v2 \
  --tier free \
  --enable-managed-identity \
  --enable-addons monitoring \
  --generate-ssh-keys

echo "=== 5. Obteniendo Credenciales para kubectl ==="
az aks get-credentials --resource-group "$RG" --name "$CLUSTER_NAME" --overwrite-existing

echo "=== 6. Validando Estado del Clúster ==="
kubectl get nodes -o wide
kubectl cluster-info
