module.exports.getGoals = function (knex, callback) {
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
