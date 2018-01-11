// client.query('SELECT * from "goals"', (err, res) => {
//   // console.log(err, res);
//   console.log(res.rows);
//   client.end();
// });


exports.handler = (event, context, callback) => {
  // TODO implement
  const { Client } = require('pg');

  const client = new Client({
    user: 'awsuser',
    host: 'habitz.cyxlajx2dt6m.us-east-1.rds.amazonaws.com',
    database: 'habitz_production',
    password: 'gopher19hbai',
    port: 5432,
  });

  console.log('Received event:', JSON.stringify(event, null, 2));
  console.log(process.env.NODE_ENV);

  const path = event.path;
  const resource = event.resource;
  const method = event.httpMethod;
  let responseBody = '';
  const params = event.pathParameters;

  switch (resource) {
    case '/goals':
      switch (method) {
        case 'GET':
          responseBody = 'get all goals';
          break;
        case 'POST':
          responseBody = 'create a new goal';
          break;
        default:
      }
      break;

    case '/goals/{goalid}':
      switch (method) {
        case 'GET':
          responseBody = `get a specific goal with id ${params.goalid}`;
          break;
        case 'PATCH':
          responseBody = `edit a specific goal with id ${params.goalid}`;
          break;
        case 'DELETE':
          responseBody = `delete a specific goal with id ${params.goalid}`;
          break;
        default:
      }
      break;
    default:
  }

  // The output from a Lambda proxy integration must be
  // of the following JSON object. The 'headers' property
  // is for custom response headers in addition to standard
  // ones. The 'body' property  must be a JSON string. For
  // base64-encoded payload, you must also set the 'isBase64Encoded'
  // property to 'true'.
  const responseCode = 200;

  const response = {
    statusCode: responseCode,
    headers: {
      'x-custom-header': 'my custom header value',
    },
    body: JSON.stringify(responseBody),
  };

  console.log(`response: ${JSON.stringify(response)}`);

  client.end();
  callback(null, response);
};
