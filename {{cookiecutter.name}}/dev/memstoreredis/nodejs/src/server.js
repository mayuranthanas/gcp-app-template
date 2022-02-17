'use strict';
const http = require('http');
const redis = require('redis');

const REDISHOST = process.env.REDIS_IP || 'localhost';
const REDISPORT = process.env.REDIS_PORT || 6379;

const client = redis.createClient(REDISPORT, REDISHOST);
client.on('error', err => console.error('ERR:REDIS:', err));

// create a server
http
  .createServer((req, res) => {
    // Add a key to redis
    client.set("node_key1", "Hello world from Redis");
      

    res.writeHead(200, {'Content-Type': 'text/plain'});
    
    client.get('node_key1', function(err, reply) {
      res.end('Sample Nodejs accessing Memorystore for Redis: ' +  reply);
    });    
  })
  .listen(8080);