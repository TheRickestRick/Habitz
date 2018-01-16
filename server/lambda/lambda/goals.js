module.exports.getGoals = function (knex, callback) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('goals')
    .then((goals) => {
      console.log('received goals: ', goals);
      response.body = JSON.stringify(goals);
      callback(null, response);
    })
    .catch((err) => {
      console.log('error occurred: ', err);
      callback(err);
    });
};

module.exports.getGoalsForUser = function (knex, callback, user_uid) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('goals')
    .where({ user_uid: user_uid })
    .then((goals) => {
      console.log('received goals: ', goals);
      response.body = JSON.stringify(goals);
      callback(null, response);
    })
    .catch((err) => {
      console.log('error occurred: ', err);
      callback(err);
    });
};
