'use strict';
const express = require('express');
const {PubSub} = require('@google-cloud/pubsub');

// topic name format: 'projects/<project id>/topics/<topic name>
const TOPIC_NAME = process.env.TOPIC_NAME;
// subscription name format: 'projects/<project id>/subscriptions/<subscription name>
const SUBSCRIPTION_NAME = process.env.SUBSCRIPTION_NAME;
const PROJECT_ID_NP = process.env.PROJECT_ID_NP;

const {v1} = require('@google-cloud/pubsub');
// Creates a client; cache this for further use.
const subClient = new v1.SubscriberClient();

// Creates a pubsub client
const app = express();
const pubSubClient = new PubSub();

app.get('/', async (req, res) => {
  let ret = '<h1>Sample Nodejs with GCP PubSub</h1>';

  ret += '<a href=/pubsub>Try PubSub </a>';
    
  res.send(ret);
});

app.get('/pubsub', async (req, res) => {
  let ret = '<h1>Sample Nodejs with GCP PubSub</h1>';

  var moment = require('moment'); 

  // publish messages to topic
  ret += '<h3>Topic: ' + TOPIC_NAME + '</h3><br>';
  ret += '=================<br>';
  ret += moment().format('h:mm:ss a') + '<br>';
  try{
    const pubres = await publishMessage()
    ret += pubres;
  }catch(e){console.log(e)};
    

  ret += '<h3>Subscription: ' + SUBSCRIPTION_NAME + '</h3><br>';
  ret += '=================<br>';
  try{
    const subres = await listenForMessages()
    ret += subres;
  }catch(e){console.log(e)};
  
  res.send(ret);
});

async function publishMessage() {
  const num_Messages = 3;
  const topic_path = `projects/${PROJECT_ID_NP}/topics/${TOPIC_NAME}`;
  let res = `--- Publishing ${num_Messages} messages ---<br>`;
  console.log(`publishMessage started...`);
  try {
    for (var i = 0; i < num_Messages; i++) {
      const msg = `Message # ${i}`;
      console.log(`Publishing Message ${msg} ....`);
      const dataBuffer = Buffer.from(msg);
      const messageId = await pubSubClient.topic(topic_path).publish(dataBuffer);
      console.log(`Message ${messageId} published.`);
      res += msg + ' published <br>';
    }    
  } catch (error) {
    throw new Error(error);
  }
  return res;
}

async function listenForMessages() {
  const num_Messages = 10;
  // create the subscription path with project id and subscription name
  const formattedSubscription = subClient.subscriptionPath(
    PROJECT_ID_NP,
    SUBSCRIPTION_NAME
  );

  let res = `Listening on subscription: ${SUBSCRIPTION_NAME}<br>`;

  // The maximum number of messages returned for this request.
  // Pub/Sub may return fewer than the number specified.
  const request = {
    subscription: formattedSubscription,
    maxMessages: num_Messages
  };

  // The subscriber pulls a specified number of messages.
  const [response] = await subClient.pull(request);

  // Process the messages.
  const ackIds = [];
  for (const message of response.receivedMessages) {
    //console.log(`Received message: ${message.message.data}`);
    res += `Received ${message.message.data}<br>`;
    ackIds.push(message.ackId);
  }
  
  if (ackIds.length !== 0) {
    // Acknowledge all of the messages. You could also acknowledge
    // these individually, but this is more efficient.
    const ackRequest = {
      subscription: formattedSubscription,
      ackIds: ackIds,
    };
    await subClient.acknowledge(ackRequest);
  }

  return res;
}

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('Sample Nodejs with GCP PubSub listening on port', port);
});