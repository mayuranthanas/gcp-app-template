'use strict';
const express = require('express');
const Firestore = require('@google-cloud/firestore');

// collection_name: this is set in the environment variables.
const COLLECTION_NAME = process.env.COLLECTION_NAME;
// sample document name
const DOCUMENT_NAME = 'sample-doc-from-nodejs';


const app = express();
const db = new Firestore({
  projectId: process.env.PROJECT_ID_NP
});

app.get('/', async (req, res) => {
  let ret = '<h1>Sample Nodejs with GCP Firestore</h1>';

  ret += '<a href=/firestore>Try Firestore </a>';
    
  res.send(ret);
});

app.get('/firestore', async (req, res) => {
  let ret = '<h1>Sample Nodejs with GCP Firestore</h1>';

  var moment = require('moment'); 

  // add sample document to collection
  ret += '<h3>Collection: ' + COLLECTION_NAME + '</h3><br>';
  ret += '=================<br>';

  const docRef = db.collection(COLLECTION_NAME).doc(DOCUMENT_NAME);
  const doc = await docRef.get();
  if (doc.exists) {
    ret += 'Sample document already exists, deleting document...<br>';
    await db.collection(COLLECTION_NAME).doc(DOCUMENT_NAME).delete();
  } 

  // now create the sample document
  const data = {
      project: process.env.PROJECT_ID_NP,
      app: 'Sample Nodejs app for Firestore',
      message: 'Hello Firestore from Nodejs',
      time_stamp: moment().format('h:mm:ss a')
  };
  const result = await db.collection(COLLECTION_NAME).doc(DOCUMENT_NAME).set(data);
  ret += 'Created sample document' + DOCUMENT_NAME + '<br>';
  ret += '=================<br>';

  ret += 'Querying sample document' + DOCUMENT_NAME + '<br>';
  const rRef = db.collection(COLLECTION_NAME).doc(DOCUMENT_NAME);
  const rdoc = await rRef.get();
  if (!rdoc.exists) {
    console.log('No such document!');
  } else {
    ret +=  rdoc.data();
  }

  res.send(ret);
});


const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('Sample Nodejs for GCP Firestore listening on port', port);
});