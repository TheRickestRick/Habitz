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

// const goals = require('goals');

exports.handler = (event, context, callback) => {
  console.log('event received: ', event);
  console.log('knex connection: ', knex);

  // goals.getGoals(knex, callback);
  // knex.destroy();

  knex('goals')
    .then((goals) => {
      console.log('received goals: ', goals);
      knex.destroy();
      return callback(null, goals);
    })
    .catch((err) => {
      console.log('error occurred: ', err);
      knex.destroy();
      return callback(err);
    });
};
