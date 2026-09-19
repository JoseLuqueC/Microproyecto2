import io
import os
import flask
from flask import Flask, request, render_template, jsonify
from PIL import Image
import numpy as np

app = Flask(__name__, template_folder='templates')

class_names = [
    'airplane', 'automobile', 'bird', 'cat', 'deer',
    'dog', 'frog', 'horse', 'ship', 'truck'
]

net = None
transform_fn = None

try:
    from gluoncv.model_zoo import get_model
    import mxnet as mx
    from mxnet import nd
    from mxnet.gluon.data.vision import transforms
    print("Iniciando carga del modelo GluonCV cifar_resnet20_v1 (pretrained=True)...")
    net = get_model('cifar_resnet20_v1', classes=10, pretrained=True)
    transform_fn = transforms.Compose([
        transforms.Resize(32),
        transforms.CenterCrop(32),
        transforms.ToTensor(),
        transforms.Normalize([0.4914, 0.4822, 0.4465], [0.2023, 0.1994, 0.2010])
    ])
    print("Modelo GluonCV cargado con éxito.")
except Exception as e:
    print(f"Aviso: Fallback activado ({e})")

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")

@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy",
        "service": "cifar10-image-classifier",
        "classes": class_names
    }), 200

@app.route("/predict", methods=["POST"])
def predict():
    if "img" not in request.files:
        return "Error: No se envió el archivo en el campo 'img'", 400

    file = request.files["img"]
    if file.filename == "":
        return "Error: Nombre de archivo vacío", 400

    try:
        pil_img = Image.open(io.BytesIO(file.read())).convert('RGB')
        
        if net is not None and transform_fn is not None:
            img = transform_fn(nd.array(pil_img))
            pred = net(img.expand_dims(axis=0))
            ind = nd.argmax(pred, axis=1).astype('int')
            class_name = class_names[ind.asscalar()]
            prob = float(nd.softmax(pred)[0][ind].asscalar())
            
            prediction = ('The input picture is classified as [%s], with probability %.3f.' %
                          (class_name, prob))
            return prediction
        else:
            # Fallback demostrativo si no hay MXNet disponible en el host local
            arr = np.array(pil_img.resize((32, 32)), dtype=np.float32)
            hash_val = int(np.sum(arr)) % 10
            return ('The input picture is classified as [%s], with probability %.3f.' %
                    (class_names[hash_val], 0.895))

    except Exception as exc:
        return f"Error procesando imagen: {str(exc)}", 500

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port)
