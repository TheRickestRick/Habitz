module.exports.getHabits = function (knex, callback) {
  const response = {
    statusCode: 200,
    body: JSON.stringify(responseBody),
  };

  knex('habits')
    .then((habits) => {
      console.log('received habits: ', habits);
      response.body = JSON.stringify(habits)
      callback(null, response);
    })
    .catch((err) => {
      console.log('error occurred: ', err);
      callback(err);
    });
};

module.exports.getHabitsForUser = function (knex, callback, user_uid) {
  knex('habits')
    .where({ user_uid: req.query.user_uid })
    .then((habits) => {
      console.log('received habits: ', habits);
      callback(null, habits);
    })
    .catch((err) => {
      console.log('error occurred: ', err);
      callback(err);
    });
};
