import os
import sys
import time

import logging
from flask import Flask 
from concurrent import futures
from concurrent.futures import TimeoutError
from google.cloud import firestore 
from datetime import datetime

app = Flask(__name__) 

appPort = os.environ.get('PORT', 8080)
collection_name =  os.environ.get('COLLECTION_NAME', '')
document_name = 'sample doc from python'
project_id_np = os.environ.get('PROJECT_ID_NP', '')

@app.route('/')
def index():
    ret = '<h1>Sample Python MicroService</h1><h2>GCP Firestore</h2><br>'
    ret += '<a href=/firestore>Try Firestore Sample</a>'
    return ret

@app.route('/firestore')
def pubsub():
    ret = '<h1>Sample Python MicroService</h1><h2>Firestore</h2><br>'
    ret += '<h3>Collection: {}</h3>'.format(collection_name)
    print(f"Creating firestore handler for project: {project_id_np}")
    db = firestore.Client(project=project_id_np)

    print(f"check if sample document already exists...")
    # check if the sample document alread exists
    doc_ref = db.collection(collection_name).document(document_name)
    doc = doc_ref.get()
    if doc.exists:
        print(f"deleting sample document...")
        # sample document exists, deleting sample doc
        ret += 'Deleting existing sample document...<br>'
        db.collection(collection_name).document(document_name).delete()
        print(f"deleted sample document!")
        
    print(f"adding sample document...")
    ret += 'Adding sample document {}...<br>'.format(document_name)
    data = {"app": "Los Angeles", "project":"Starter-Kit Python + Firestore", "message": "Hello Firestore from Python", "time_stamp": datetime.now().strftime("%H:%M:%S")}

    # Add a new doc in collection 'cities' with ID 'LA'
    db.collection(collection_name).document(document_name).set(data)
    ret += 'Added sample document {}<br>'.format(document_name)
    ret += '=====================<br>'
    print(f"added sample document!")
        

    print(f"querying sample document...")
    ret += 'Querying sample document {}<br>'.format(document_name)
    doc_ref = db.collection(collection_name).document(document_name)
    doc = doc_ref.get()
    if doc.exists:
        print(f"Query result: {doc.to_dict()}")
        ret += 'Document data: <br>'
        ret += str(doc.to_dict())
    
    return ret

@app.errorhandler(500)
def server_error(e):
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500


if __name__ == '__main__':
    # This is used when running locally. Gunicorn is used to run the
    # application on Google App Engine and Cloud Run.
    # See entrypoint in app.yaml or Dockerfile.
    app.run(host='0.0.0.0', port=8080, debug=True)
