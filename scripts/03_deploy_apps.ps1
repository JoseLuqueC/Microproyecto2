# scripts/03_deploy_apps.ps1
# Despliega todas las aplicaciones en AKS

Write-Host "Desplegando Clasificador de Imágenes CIFAR-10 (Deep Learning)..." -ForegroundColor Cyan
kubectl apply -f ..\k8s-manifests\01-image-classifier.yaml

Write-Host "Desplegando Aplicación de Interés (Podinfo UAO)..." -ForegroundColor Cyan
kubectl apply -f ..\k8s-manifests\02-app-interes.yaml

Write-Host "Configurando Horizontal Pod Autoscaler (HPA - Punto Extra)..." -ForegroundColor Cyan
kubectl apply -f ..\k8s-manifests\03-hpa-extra.yaml

Write-Host "Esperando asignación de External IPs por Azure Load Balancer..." -ForegroundColor Yellow
kubectl get svc -w
