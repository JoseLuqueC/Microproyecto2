# Microproyecto 2: Implementación de Clúster Kubernetes en Azure (AKS)
**Asignatura:** Computación en la Nube  
**Universidad Autónoma de Occidente (UAO)**  
**Facultad de Ingeniería**

---

## 👥 Integrantes del Equipo
* José Luque (`jose.luque@uao.edu.co`)
* [Nombre Compañero 2]
* [Nombre Compañero 3]

---

## 📌 Descripción del Proyecto
Este proyecto implementa y valida un clúster administrado de **Azure Kubernetes Service (AKS)** de 2 nodos en Microsoft Azure con suscripción de *Azure for Students*. Incluye el despliegue de dos aplicaciones en alta disponibilidad (clasificador de imágenes con Deep Learning y microservicio cloud-native), servicios de supervisión en Azure y autoescalado horizontal (HPA).

---

## 🏛️ Arquitectura de la Solución
* **Plano de Control:** Kubernetes v1.35.7 administrado por Azure (Tier Free).
* **Nodos de Trabajo:** 2 nodos `standard_b2ps_v2` (procesadores ARM64 Ampere Altra de 2 vCPUs y 4 GiB RAM c/u) en la región `westus`.
* **Identidad y Seguridad:** Identidad administrada por el sistema (`SystemAssigned Managed Identity`).
* **Monitoreo:** Azure Container Insights integrado con Azure Monitor y Log Analytics.
* **Red:** Azure CNI Overlay con Azure Load Balancer externo asignando IPs públicas a cada servicio.

---

## 📁 Estructura del Repositorio
```text
Microproyecto2/
├── app-image-classifier/           # Código fuente y recursos del Clasificador CIFAR-10
│   ├── app.py                      # Servidor Flask con endpoints /predict, /health y web UI
│   ├── templates/index.html        # Interfaz web interactiva para clasificar imágenes
│   └── test_images/                # Imágenes de prueba (horse.jpeg, dog.jpeg, airplane.jpeg)
├── k8s-manifests/                  # Manifiestos declarativos de Kubernetes
│   ├── 01-image-classifier.yaml    # ConfigMap + Deployment + Service LoadBalancer
│   ├── 02-app-interes.yaml         # Deployment + Service LoadBalancer de Podinfo UAO
│   └── 03-hpa-extra.yaml           # Horizontal Pod Autoscaler (Escalado de 2 a 6 pods)
├── scripts/                        # Scripts de automatización y administración
│   ├── 01_verify_and_register.ps1  # Registro de Resource Providers y chequeo de políticas
│   ├── 02_create_aks.ps1           # Creación y aprovisionamiento del clúster AKS
│   ├── 03_deploy_apps.ps1          # Despliegue de los manifiestos en el clúster
│   ├── start_cluster.ps1           # Reanudación rápida del clúster
│   ├── stop_cluster.ps1            # Detención y desasignación para ahorro de créditos ($0)
│   └── destroy_cluster.ps1         # Eliminación completa del Resource Group
├── GUIA_SUSTENTACION.md            # Guion de sustentación dividido para 3 personas
└── README.md                       # Documentación general del proyecto
```

---

## 🚀 Despliegue y Pruebas

### 1. Reanudar el clúster antes de las pruebas:
```powershell
az aks start --name aks-microproyecto2 --resource-group rg-microproyecto2
az aks get-credentials --resource-group rg-microproyecto2 --name aks-microproyecto2 --overwrite-existing
```

### 2. Verificar Nodos y Servicios:
```powershell
kubectl get nodes -o wide
kubectl get svc
```

### 3. Prueba de Inferencia cURL (Clasificador Deep Learning):
```powershell
curl.exe -s -X POST -F "img=@app-image-classifier/test_images/horse.jpeg" http://172.185.25.247/predict
```
*Salida esperada:*
```text
The input picture is classified as [horse], with probability 0.892.
```

### 4. Prueba en Navegador:
* **Clasificador CIFAR-10:** `http://172.185.25.247/`
* **Microservicio Podinfo UAO:** `http://20.66.66.209/`

### 5. Demostración de Autoescalado (HPA):
```powershell
# En una terminal vigilar el HPA:
kubectl get hpa podinfo-hpa -w

# En otra terminal generar tráfico de prueba:
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://podinfo; done"
```

---

## 🛡️ Cuidado de Créditos y Limpieza
Para detener el clúster y evitar consumo de cómputo mientras no se esté utilizando:
```powershell
az aks stop --name aks-microproyecto2 --resource-group rg-microproyecto2
```
Para eliminar definitivamente todos los recursos al finalizar la sustentación:
```powershell
az group delete --name rg-microproyecto2 --yes --no-wait
```
