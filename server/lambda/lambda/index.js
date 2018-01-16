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

  // knex('goals')
  //   .then((goals) => {
  //     console.log('received goals: ', goals);
  //     callback(null, goals);
  //   })
  //   .catch((err) => {
  //     console.log('error occurred: ', err);
  //     callback(err);
  //   });
  goals.getGoals(knex, callback);
};
