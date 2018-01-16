const knex = require('knex')({
  client: 'pg',
  connection: {
    host: 'habitzpg.cyxlajx2dt6m.us-east-1.rds.amazonaws.com',
    port: 5432,
    user: 'wittrura',
    password: 'gopher19',
    database: 'habitz_production',
  },
});

const goals = require('goals')

exports.handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;

  console.log('event received: ', event);

  if (event.pathParameters !== null) {
    console.log('handle request for id: ', event.pathParameters.id);
    let goalId = event.pathParameters.id

    switch (event.httpMethod) {
      case 'GET':
        goals.get(knex, callback, goalId);
        break;

      case 'PATCH':
        goals.patch(knex, callback, goalId, event.body);
        break;

      case 'DELETE':
        goals.delete(knex, callback, goalId)
        break

      default:
        callback('ERROR: invalid method');
    }

  } else if (event.queryStringParameters) {
    // check for a query string

    // check for a user_uid
    if (event.queryStringParameters.user_uid) {
      goals.getAll(knex, callback, event.queryStringParameters.user_uid);
    }

  } else {
    switch (event.httpMethod) {
      case 'GET':
        goals.getAll(knex, callback);
        break;

      case 'POST':
        goals.post(knex, callback, event.body)
        break;

      default:
        callback('ERROR: invalid method');
    }
  }
  // knex('goals')
  //   .then((goals) => {
  //     console.log('received goals: ', goals);
  //     callback(null, goals);
  //   })
  //   .catch((err) => {
  //     console.log('error occurred: ', err);
  //     callback(err);
  //   });

};
