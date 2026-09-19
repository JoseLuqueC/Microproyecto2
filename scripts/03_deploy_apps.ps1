# scripts/03_deploy_apps.ps1
# Despliega las aplicaciones en AKS

Write-Host "Desplegando Aplicación de Interés (Azure Vote / Redis)..." -ForegroundColor Cyan
kubectl apply -f ..\k8s-manifests\02-app-interes.yaml

Write-Host "Esperando asignación de External IP para azure-vote-front..." -ForegroundColor Yellow
kubectl get svc azure-vote-front -w
