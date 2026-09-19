# start_cluster.ps1
# REANUDA EL CLÚSTER AKS CUANDO VAYAS A TRABAJAR O SUSTENTAR

$rg = "rg-microproyecto2"
$clusterName = "aks-microproyecto2"

Write-Host "Reanudando clúster AKS $clusterName..." -ForegroundColor Cyan
az aks start --name $clusterName --resource-group $rg
Write-Host "Clúster iniciado. Obteniendo credenciales..." -ForegroundColor Green
az aks get-credentials --resource-group $rg --name $clusterName --overwrite-existing
kubectl get nodes
