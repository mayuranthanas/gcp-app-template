import os
import sys
import time

import logging
from flask import Flask 
from concurrent import futures
from concurrent.futures import TimeoutError
from google.cloud import pubsub_v1
from google.api_core import retry 
from datetime import datetime

app = Flask(__name__) 

appPort = os.environ.get('PORT', 8080)
topic_name =  os.environ.get('TOPIC_NAME', '')
sub_name = os.environ.get('SUBSCRIPTION_NAME', '')
project_id_np = os.environ.get('PROJECT_ID_NP', '')
timeout = 30.0

@app.route('/')
def index():
    ret = '<h1>Sample Python MicroService</h1><h2>Pub/Sub Publish and Subscribe</h2><br>'
    ret += '<a href=/pubsub>Try PubSub Sample</a>'
    return ret

@app.route('/pubsub')
def pubsub():
    ret = '<h1>Sample Python MicroService</h1><h2>Pub/Sub Publish and Subscribe</h2><br>'
    ret += '<h3>Topic: {}</h3>'.format(topic_name)
    
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id_np, topic_name)
    for i in range(5):
        msg = 'Message: ' + datetime.now().strftime("%H:%M:%S") + '--' + str(i)
        publisher.publish(topic_path, msg.encode())
        ret += '=====> published message' + msg + '<br>'
               
    ret += '<br>=====================<br>'
    ret += '<h3>Subscription: {}</h3>'.format(sub_name)
    subscriber = pubsub_v1.SubscriberClient()
    subscription_path = subscriber.subscription_path(project_id_np, sub_name)
    NUM_MESSAGES = 5        
    with subscriber:
        # The subscriber pulls a specific number of messages. The actual
        # number of messages pulled may be smaller than max_messages.
        response = subscriber.pull(
            request={"subscription": subscription_path, "max_messages": NUM_MESSAGES},
            retry=retry.Retry(deadline=300),
        )
        ack_ids = []
        for received_message in response.received_messages:
            ret += '<===== Received: ' + received_message.message.data.decode() + '<br>'
            ack_ids.append(received_message.ack_id)

        # Acknowledges the received messages so they will not be sent again.
        if ack_ids:
            subscriber.acknowledge(request={"subscription": subscription_path, "ack_ids": ack_ids})

        print(
            f"Received and acknowledged {len(response.received_messages)} messages from {subscription_path}."
        )
    
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
