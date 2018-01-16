module.exports.getGoals = function (knex, callback) {
  knex('goals')
    .then((goals) => {
      console.log('received goals: ', goals);
      callback(null, goals);
    })
    .catch((err) => {
      console.log('error occurred: ', err);
      callback(err);
    });
};
