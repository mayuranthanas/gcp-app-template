import os

from flask import Flask 
import redis

app = Flask(__name__) 

appPort = os.environ.get('PORT', 8080)

redis_host = os.environ.get('REDIS_IP', '127.0.0.1')
redis_port =  os.environ.get('REDIS_PORT', 6379)

redis_client = redis.StrictRedis(host=redis_host, port=redis_port)

@app.route('/')
def index():
    redis_client.set('key_1', 'Hello World from Memorystore for Redis!')
    val_from_redis = redis_client.get('key_1')
    strToShow = '<h1>Sample Python MicroService</h1><h2>Getting Data From Memorystore for Redis Cache</h2><br>'
    strToShow = strToShow + '<h3>key_1:</h3> <br>'
    if val_from_redis :  
        strToShow = strToShow + val_from_redis.decode('utf8') + '<br/>=========<br/>' 

    return strToShow

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
