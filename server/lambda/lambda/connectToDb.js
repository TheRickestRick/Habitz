
// const knex = require('knex')({
//   client: 'pg',
//   connection: {
//     host: 'habitzpg.cyxlajx2dt6m.us-east-1.rds.amazonaws.com',
//     port: 5432,
//     user: 'wittrura',
//     password: 'gopher19',
//     database: 'habitz_production',
//   },
// });

function generateConnection() {
  return require('knex')({
    client: 'pg',
    connection: {
      host: 'habitzpg.cyxlajx2dt6m.us-east-1.rds.amazonaws.com',
      port: 5432,
      user: 'wittrura',
      password: 'gopher19',
      database: 'habitz_production',
    },
  });
}

// knex.client.destroy();
Promise.resolve(generateConnection())
  .then((connection) => {
    const knex = connection;
    console.log('initialized connection');

    knex('goals')
      .then((goals) => {
        console.log('received goals: ', goals);
        knex.client.destroy();
      })
      .catch((err) => {
        console.log('error occurred: ', err);
        knex.client.destroy();
      });
  })
  .catch(() => {
    console.log('error during pool init');
  });


console.log('this is after the query');
