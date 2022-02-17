const express = require('express');
const {Storage} = require('@google-cloud/storage');  
const app = express();

app.get('/', async (req, res) => {
    
  const sb = process.env.STORAGE_BUCKET;
  console.log('Sample Node App Accessing GCS: ' + sb);
  const storage = new Storage();
  let flist = '<h3>Nodejs Sample Accessing Storage Bucket: ' + sb + '</h3>';
  flist += '<p>Files in bucket:</p>';
  try
  {
    [files] = await storage.bucket(sb).getFiles();
    files.forEach(file => {
        flist += `<p>---${file.name}</p>`;
    });     
  }catch (error) {
    console.log(error)
  }  
  res.send(flist);
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('Hello world listening on port', port);
});