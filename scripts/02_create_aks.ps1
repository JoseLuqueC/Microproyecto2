# 02_create_aks.ps1
# Script para crear el clúster AKS económico (standard_b2ps_v2, 2 nodos)

$rg = "rg-microproyecto2"
$location = "westus"
$clusterName = "aks-microproyecto2"

Write-Host "Creando grupo de recursos: $rg en $location..." -ForegroundColor Cyan
az group create --name $rg --location $location

Write-Host "Creando clúster AKS: $clusterName (2 nodos standard_b2ps_v2, Tier Free)..." -ForegroundColor Cyan
az aks create `
  --resource-group $rg `
  --name $clusterName `
  --node-count 2 `
  --node-vm-size standard_b2ps_v2 `
  --tier free `
  --enable-managed-identity `
  --enable-addons monitoring `
  --generate-ssh-keys

Write-Host "Obteniendo credenciales para kubectl..." -ForegroundColor Cyan
az aks get-credentials --resource-group $rg --name $clusterName --overwrite-existing

Write-Host "Comprobando funcionamiento del clúster..." -ForegroundColor Green
kubectl get nodes -o wide
kubectl cluster-info
