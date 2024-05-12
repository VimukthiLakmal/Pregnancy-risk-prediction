from flask import Flask, request, jsonify
import pickle
import numpy as np
import skmultilearn
import sklearn
from scipy.sparse import hstack, issparse, lil_matrix
from flask_cors import CORS
import joblib
md = joblib.load('model.h5')

app = Flask(__name__)
CORS(app)

@app.route('/predict', methods=['POST'])
def model():
    data = []
    res = []

    d1 = request.json.get('age')
    d2 = request.json.get('sbp')
    d3 = request.json.get('dbp')
    d4 = request.json.get('bs')
    d5 = request.json.get('bt')
    d6 = request.json.get('hr')
    
    data.append(d1)
    data.append(d2)
    data.append(d3)
    data.append(d4)
    data.append(d5)
    data.append(d6)
    
    arr = np.asarray(data)
    arr = arr.reshape(1, -1)
    result = md.predict(arr)
 
    if  result[0] == 0:
        res.append('Low Risk')
    elif result[0] ==1:
        res.append('Mid Risk')
    elif result[0] ==2:
        res.append('High Risk')
   
 
    return jsonify(res)


if __name__ == '__main__':
    app.run()
