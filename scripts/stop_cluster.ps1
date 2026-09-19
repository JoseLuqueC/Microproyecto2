# stop_cluster.ps1
# DETIENE LOS NODOS DE AKS PARA NO GASTAR CRÉDITOS MIENTRAS NO SE USE

$rg = "rg-microproyecto2"
$clusterName = "aks-microproyecto2"

Write-Host "Deteniendo clúster AKS $clusterName para pausar el cobro de cómputo..." -ForegroundColor Yellow
az aks stop --name $clusterName --resource-group $rg
Write-Host "Clúster detenido exitosamente. Los créditos de Azure están a salvo." -ForegroundColor Green
