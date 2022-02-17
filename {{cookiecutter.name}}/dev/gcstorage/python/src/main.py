import os
import sys
from google.cloud import storage
from google.cloud.exceptions import NotFound
from google.cloud.exceptions import Forbidden

from flask import Flask 

app = Flask(__name__) 

appPort = os.environ.get('PORT', 8080)
storage_bucket =  os.environ.get('STORAGE_BUCKET', '')

@app.route('/')
def index():
    ret = '<h1>Sample Python MicroService</h1><h2>Listing files in Google Cloud Storage Bucket</h2><br>'
    ret += '<h3>Bucket: {}</h3>'.format(storage_bucket)

    client = storage.Client()
    try:
        # Instantiate the bucket.
        bucket = client.bucket(storage_bucket)
        # Get the bucket.
        bucket = client.get_bucket(storage_bucket)
        # Lists all the blobs in the bucket.
        blobs = bucket.list_blobs()
        for blob in blobs:
            ret += ' -' + blob.name + '\t--- size:' + str(blob.size) + '<br>'
        ret += '--------'
    except NotFound:
        ret += 'Error: Bucket does NOT exists!'
        pass
    except Forbidden:
        ret += 'Error: Forbidden, Access to bucket is denied!'
        pass

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