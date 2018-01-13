
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

knex('goals')
  .then((goals) => {
    console.log('received goals: ', goals);
  })
  .catch((err) => {
    console.log('error occurred: ', err);
  })
  .then(() => {
    console.log('destroying connection');
    knex.destroy();
    console.log('this should be the last thing executed');
  });

console.log('this is after the query');
