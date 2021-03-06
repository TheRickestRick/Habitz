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

const goals = require('goals');
const habits = require('habits');
const completedHabits = require('completedHabits');
const completedGoals = require('completedGoals');

exports.handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;
  console.log(event);

  const { resourcePath } = event.requestContext;

  if (resourcePath === '/completedhabits') {
    completedHabits.get(knex, callback, event.queryStringParameters);

  } else if (resourcePath === '/completedgoals')  {
    completedGoals.get(knex, callback, event.queryStringParameters);

  } else if (resourcePath === '/goals' || resourcePath === '/goals/{id}') {
    // check if a path parameter is present aka goals/:id
    if (event.pathParameters !== null) {
      const goalId = event.pathParameters.id;

      switch (event.httpMethod) {
        case 'GET':
          goals.get(knex, callback, goalId);
          break;

        case 'PATCH':
          goals.patch(knex, callback, goalId, event.body);
          break;

        case 'DELETE':
          goals.delete(knex, callback, goalId);
          break;

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
      // otherwise this is to the main /goals route
      switch (event.httpMethod) {
        case 'GET':
          goals.getAll(knex, callback);
          break;

        case 'POST':
          goals.post(knex, callback, event.body);
          break;

        default:
          callback('ERROR: invalid method');
      }
    }

  } else if (resourcePath === '/habits' || resourcePath === '/habits/{id}') {
    if (event.pathParameters !== null) {
      const habitId = event.pathParameters.id;

      switch (event.httpMethod) {
        case 'GET':
          habits.get(knex, callback, habitId);
          break;

        case 'PATCH':
          habits.patch(knex, callback, habitId, event.body);
          break;

        case 'DELETE':
          habits.delete(knex, callback, habitId);
          break;

        default:
          callback('ERROR: invalid method');
      }
    } else {
      // otherwise this is to the main /goals route
      switch (event.httpMethod) {
        case 'GET':
          habits.getAll(knex, callback, event.queryStringParameters);
          break;

        case 'POST':
          habits.create(knex, callback, event.body);
          break;

        default:
          callback('ERROR: invalid method');
      }
    }

  } else if (resourcePath === '/habits/{id}/complete') {
    const habitId = event.pathParameters.id;

    switch (event.httpMethod) {
      case 'POST':
        habits.complete(knex, callback, habitId);
        break;

      case 'DELETE':
        habits.incomplete(knex, callback, habitId);
        break;

      default:
        callback('ERROR: invalid method');
    }

  } else if (resourcePath === '/goals/{id}/complete') {
    const goaldId = event.pathParameters.id;

    switch (event.httpMethod) {
      case 'POST':
        goals.complete(knex, callback, goaldId);
        break;

      case 'DELETE':
        goals.incomplete(knex, callback, goaldId);
        break;

      default:
        callback('ERROR: invalid method');
    }

  } else {
    callback('ERROR: invalid path');
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
