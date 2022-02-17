'use strict';

// Require process, so we can mock environment variables.
const process = require('process');

const express = require('express');
const Knex = require('knex');

const app = express();
app.set('view engine', 'pug');
app.enable('trust proxy');

// Automatically parse request body as form data.
app.use(express.urlencoded({extended: false}));
// This middleware is available in Express v4.16.0 onwards
app.use(express.json());

// Set Content-Type for all responses for these routes.
app.use((req, res, next) => {
  res.set('Content-Type', 'text/html');
  next();
});

// Set up a variable to hold our connection pool. It would be safe to
// initialize this right away, but we defer its instantiation to ease
// testing different configurations.
let pool;

// [START cloud_sql_postgres_knex_create_tcp]
const createTcpPool = config => {
  // Extract host and port from socket address
  //const dbSocketAddr = process.env.DB_HOST.split(':'); // e.g. '127.0.0.1:5432'
  const dbSocketAddr = ('127.0.0.1:5432').split(':');
  // Establish a connection to the database
  return Knex({
    client: 'pg',
    // connection: {
    //   user: process.env.DB_USER, // e.g. 'my-user'
    //   password: process.env.DB_PASS, // e.g. 'my-user-password'
    //   database: process.env.DB_NAME, // e.g. 'my-database'
    //   host: dbSocketAddr[0], // e.g. '127.0.0.1'
    //   port: dbSocketAddr[1], // e.g. '5432'
    // },
    connection: {
      user: 'postgres', // e.g. 'my-user'
      password: 'sW3MrpUNc1yp6MOA', // e.g. 'my-user-password'
      database: 'APPDB-f6880724', // e.g. 'my-database'
      host: dbSocketAddr[0], // e.g. '127.0.0.1'
      port: dbSocketAddr[1], // e.g. '5432'
    },
    // ... Specify additional properties here.
    ...config,
  });
};

// Initialize Knex, a Node.js SQL query builder library with built-in connection pooling.
const createPool = () => {
  // Configure which instance and what database user to connect with.
  // Remember - storing secrets in plaintext is potentially unsafe. Consider using
  // something like https://cloud.google.com/kms/ to help keep secrets secret.
  const config = {pool: {}};

  // [START cloud_sql_postgres_knex_limit]
  // 'max' limits the total number of concurrent connections this pool will keep. Ideal
  // values for this setting are highly variable on app design, infrastructure, and database.
  config.pool.max = 5;
  // 'min' is the minimum number of idle connections Knex maintains in the pool.
  // Additional connections will be established to meet this value unless the pool is full.
  config.pool.min = 5;
  // [END cloud_sql_postgres_knex_limit]

  // [START cloud_sql_postgres_knex_timeout]
  // 'acquireTimeoutMillis' is the number of milliseconds before a timeout occurs when acquiring a
  // connection from the pool. This is slightly different from connectionTimeout, because acquiring
  // a pool connection does not always involve making a new connection, and may include multiple retries.
  // when making a connection
  config.pool.acquireTimeoutMillis = 60000; // 60 seconds
  // 'createTimeoutMillis` is the maximum number of milliseconds to wait trying to establish an
  // initial connection before retrying.
  // After acquireTimeoutMillis has passed, a timeout exception will be thrown.
  config.createTimeoutMillis = 30000; // 30 seconds
  // 'idleTimeoutMillis' is the number of milliseconds a connection must sit idle in the pool
  // and not be checked out before it is automatically closed.
  config.idleTimeoutMillis = 600000; // 10 minutes
  // [END cloud_sql_postgres_knex_timeout]

  // [START cloud_sql_postgres_knex_backoff]
  // 'knex' uses a built-in retry strategy which does not implement backoff.
  // 'createRetryIntervalMillis' is how long to idle after failed connection creation before trying again
  config.createRetryIntervalMillis = 200; // 0.2 seconds
  // [END cloud_sql_postgres_knex_backoff]
  
  return createTcpPool(config);
};

const getTableData = async pool => {
  return await pool
    .select('id', 'title', 'description')
    .from('sample-app.item')
    .limit(5);
};

app.get('/', async (req, res) => {
  res.send("Hello World!");
});

app.get('/database', async (req, res) => {
  pool = pool || createPool();
  try {
    // Query the 'item' table from the database.
    const rows = await getTableData(pool, 'TABS');
    res.send(rows);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .send('Unable to load database table; see logs for more details.')
      .end();
  }
});
const PORT = process.env.PORT || 8080;
const server = app.listen(PORT, () => {
  console.log(`App listening on port ${PORT}`);
  console.log('Press Ctrl+C to quit.');
});

module.exports = server;
