# Evidencia y Guía de Sustentación - Microproyecto 2 (AKS)

**Asignatura:** Computación en la Nube  
**Integrantes:**  
* Julio Cesar Rosero Porras  
* Jose Fernando Luque Cajiao (`jose.luque@uao.edu.co`)  
* Karoll Dahian Ramirez Marulanda  
**Institución:** Universidad Autónoma de Occidente  
**Suscripción:** Azure for Students (`c7fc4381-3a81-4d53-8d8d-c69a2fafe363`)  
**Grupo de Recursos:** `rg-microproyecto2` (Región: `westus`)  
**Clúster AKS:** `aks-microproyecto2` (2 Nodos: `standard_b2ps_v2`, Tier Free)

---

## 📊 Resumen de Cumplimiento de la Rúbrica (Calificación: 5.0 / 5.0 + 0.5 Extra)

| Ítem | Requerimiento | Estado | Evidencia / Endpoint |
| :--- | :--- | :--- | :--- |
| **Preg 1 (1.0)** | Clúster AKS $\ge$ 2 nodos verificado por Cloud Shell y CLI | ✅ **100%** | `kubectl get nodes -o wide` verificado en ambas consolas |
| **Preg 2 (1.0)** | Despliegue Image Classifier (`kubermatic-dl-deployment`) | ✅ **100%** | `http://172.185.25.247/predict` y Web UI en `http://172.185.25.247/` |
| **Preg 3 (1.0)** | Despliegue de aplicación de su interés con LoadBalancer | ✅ **100%** | `http://20.66.66.209/` (Podinfo con branding UAO) |
| **Preg 4 (1.0)** | Demostración de supervisión y monitoreo en Azure | ✅ **100%** | Azure Container Insights + `kubectl top nodes` / `pods` |
| **Extra (0.5)** | Horizontal Pod Autoscaling (HPA) | ✅ **100%** | `podinfo-hpa` (Mín: 2, Máx: 6, CPU target 50%) |
| **Sustentación (1.0)**| Pregunta individual conceptual | ✅ **Preparada** | Banco de respuestas conceptuales detallado abajo |

---

## 🌐 Endpoints Públicos en Vivo

> [!IMPORTANT]
> Los dos servicios cuentan con direcciones IP públicas dedicadas asignadas por el Balanceador de Carga externo de Microsoft Azure (*Azure Load Balancer*):

1. **Clasificador de Imágenes CIFAR-10 (Deep Learning):**
   * **URL Web:** [http://172.185.25.247/](http://172.185.25.247/)
   * **Endpoint API:** `http://172.185.25.247/predict`
   * **Comando de prueba cURL:**
     ```bash
     curl.exe -s -X POST -F "img=@app-image-classifier/test_images/horse.jpeg" http://172.185.25.247/predict
     ```
   * **Respuesta obtenida:**
     ```text
     The input picture is classified as [horse], with probability 0.892.
     ```

2. **Aplicación de Interés (Podinfo UAO):**
   * **URL Web:** [http://20.66.66.209/](http://20.66.66.209/)
   * **Respuesta en formato JSON / API:**
     ```json
     {
       "hostname": "podinfo-f9d65694-l7zcm",
       "version": "6.6.0",
       "color": "#0078d4",
       "message": "Microproyecto 2 - Computacion en la Nube UAO",
       "goarch": "arm64",
       "num_cpu": "2"
     }
     ```

---

## 📈 Supervisión, Métricas y Monitoreo (Pregunta 4)

### 1. Métricas en Consola (`metrics-server` integrado)
Ejecutar en cualquier momento:
```bash
kubectl top nodes
kubectl top pods
```
**Salida real obtenida:**
```text
NAME                                CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
aks-nodepool1-34116667-vmss000000   243m         12%      1722Mi          29%         
aks-nodepool1-34116667-vmss000001   241m         12%      1547Mi          26%         

NAME                                        CPU(cores)   MEMORY(bytes)   
kubermatic-dl-deployment-7d4f55df99-7qbqf   135m         26Mi            
kubermatic-dl-deployment-7d4f55df99-hd5xq   107m         26Mi            
podinfo-f9d65694-6bdc4                      1m           13Mi            
podinfo-f9d65694-l7zcm                      1m           13Mi            
```

### 2. Monitoreo en Azure Portal (Container Insights)
1. Entra a [portal.azure.com](https://portal.azure.com) y busca tu clúster **`aks-microproyecto2`**.
2. En el menú lateral izquierdo, ve a la sección **Supervisión (Monitoring)**:
   * **Insights:** Verás el mapa de salud de los 2 nodos, utilización promedio de CPU/Memoria y porcentaje de reinicios de pods.
   * **Métricas (Metrics):** Puedes generar gráficos en vivo de tráfico de red, uso de CPU por nodo y recuento de pods.
   * **Registros (Logs):** Permite ejecutar consultas KQL directamente sobre Log Analytics.

---

## ⚡ Punto Extra: Horizontal Pod Autoscaler (HPA)

El HPA está creado y monitoreando el consumo de CPU de la aplicación:
```bash
kubectl get hpa
```
**Salida:**
```text
NAME          REFERENCE            TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
podinfo-hpa   Deployment/podinfo   cpu: 1%/50%   2         6         2          2m
```

### Cómo demostrar el autoescalado en vivo durante la sustentación:
Para hacer que escale automáticamente de 2 a 6 pods bajo tus ojos:
1. En una terminal ejecuta:
   ```bash
   kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://podinfo; done"
   ```
2. En otra terminal vigila el HPA en tiempo real:
   ```bash
   kubectl get hpa podinfo-hpa -w
   ```
   *Verás cómo el CPU supera el 50% y Kubernetes ordena automáticamente a Azure subir las réplicas a 3, 4, 5 y 6 pods.*
3. Detén la primera terminal (`Ctrl + C`) y en pocos minutos observas el *scale down* automático de regreso a 2 pods.

---

## 🛡️ Control de Créditos: Cómo Pausar y Reanudar

> [!CAUTION]
> **Para no gastar ni un solo centavo innecesario de tu suscripción de estudiante:**

### Para DETENER el clúster ahora (Pausar el cómputo y no gastar crédito):
Ejecuta en tu terminal de PowerShell o Cloud Shell:
```bash
az aks stop --name aks-microproyecto2 --resource-group rg-microproyecto2
```
*Esto desasigna las máquinas virtuales y detiene al 100% el cobro de cómputo.*

### Para REANUDAR el clúster el día de la sustentación:
```bash
az aks start --name aks-microproyecto2 --resource-group rg-microproyecto2
```
*En 2 o 3 minutos tus dos nodos, IPs públicas y servicios vuelven a estar exactamente donde los dejaste.*

### Para ELIMINAR TODO al terminar la sustentación:
```bash
az group delete --name rg-microproyecto2 --yes --no-wait
```

---

## 🎓 Banco de Preguntas Típicas para la Sustentación Individual (1.0 pt)

1. **¿Qué diferencia hay entre un `Deployment` y un `Service` en Kubernetes?**
   * *Respuesta:* El `Deployment` es el controlador que administra el ciclo de vida de los pods (crea réplicas, gestiona actualizaciones progresivas y autorrepara pods si fallan). El `Service` es la abstracción de red que provee una IP y DNS estable para balancear el tráfico hacia los pods, resolviendo el problema de que los pods tienen IPs efímeras.
2. **¿Por qué usamos un servicio de tipo `LoadBalancer` en lugar de `ClusterIP` o `NodePort`?**
   * *Respuesta:* `ClusterIP` solo es visible dentro del clúster. `NodePort` expone un puerto alto en la IP de cada nodo pero requiere abrir puertos manualmente. `LoadBalancer` es la integración nativa con la nube: le pide al controlador de Azure que cree un balanceador externo real y asigne una IP pública para recibir tráfico de internet.
3. **¿Cómo funciona el Horizontal Pod Autoscaler (HPA)?**
   * *Respuesta:* Consulta periódicamente a `metrics-server` el consumo promedio de recursos (CPU/Memoria) de los pods del deployment. Si el consumo supera el umbral configurado (en nuestro caso 50%), calcula la fórmula $Replicas = \lceil ReplicasActuales \times \frac{ConsumoActual}{ConsumoDeseado} \rceil$ y escala el deployment hasta el límite máximo definido.
4. **¿Por qué verificamos las regiones con la política `sys.regionrestriction`?**
   * *Respuesta:* Porque las suscripciones institucionales de Azure for Students aplican políticas de gobierno (*Azure Policy*) que restringen el despliegue a datacenters específicos para prevenir sobrecostos o abusos. Desplegar fuera de ellas genera el error `RequestDisallowedByPolicy`.
