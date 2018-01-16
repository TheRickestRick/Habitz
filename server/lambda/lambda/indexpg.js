const pg = require('pg')

const client = new pg.Client({
  host: 'habitzpg.cyxlajx2dt6m.us-east-1.rds.amazonaws.com',
  port: 5432,
  user: 'wittrura',
  password: 'gopher19',
  database: 'habitz_production',
});

client.connect();

exports.handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  client.query('SELECT * FROM USERS', (err, users) => {
    if (err) {
      console.log(err.stack);
    } else {
      console.log(users.rows[0]);
    }
    callback(null, users.rows);
  });
};
