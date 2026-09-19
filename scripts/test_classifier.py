# scripts/test_classifier.py
# Script para probar inferencia en el clasificador de imágenes

import sys
import requests

if len(sys.argv) < 3:
    print("Uso: python test_classifier.py <ENDPOINT_URL> <RUTA_IMAGEN>")
    print("Ejemplo: python test_classifier.py http://20.120.45.10/predict ../app-image-classifier/test_images/horse.jpeg")
    sys.exit(1)

endpoint = sys.argv[1]
image_path = sys.argv[2]

print(f"Enviando imagen {image_path} a {endpoint}...")
with open(image_path, "rb") as f:
    files = {"img": f}
    response = requests.post(endpoint, files=files)

print("Código de respuesta:", response.status_code)
print("Resultado:")
print(response.text)
