# destroy_cluster.ps1
# ELIMINA TODO EL GRUPO DE RECURSOS PARA LIBERAR 100% DE LOS RECURSOS

$rg = "rg-microproyecto2"
Write-Host "Eliminando completamente el grupo de recursos $rg..." -ForegroundColor Red
az group delete --name $rg --yes --no-wait
Write-Host "Solicitud de eliminación enviada." -ForegroundColor Green
