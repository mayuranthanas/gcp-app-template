import os

from flask import Flask 

app = Flask(__name__) 

appPort = os.environ.get('PORT', 8080)

@app.route('/')
def index():
    strToShow = '<h1>Sample Python MicroService</h1><h2>Hello World from Python</h2><br>'
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