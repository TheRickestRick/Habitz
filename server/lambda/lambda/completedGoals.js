module.exports.get = function (knex, callback, queryStringParameters) {
  const response = {
    statusCode: 200,
    body: null,
  };

  if (queryStringParameters !== null) {
    // search by user_uid, returning only completions for the previous day
    if (queryStringParameters.user_uid !== undefined && queryStringParameters.day === 'yesterday') {
      knex.from('completedgoals')
        .join('goals', 'goals.id', 'completedgoals.goal_id')
        .select('goals.id', 'goals.name', 'goals.completed_streak', 'completedgoals.created_at')
        .where({'goals.user_uid': queryStringParameters.user_uid})
        .andWhere(knex.raw('completedgoals.created_at >= CURRENT_DATE - 1 and completedgoals.created_at < CURRENT_DATE'))
        .orderBy('goals.id', 'asc')
        .then((goals) => {
          response.body = JSON.stringify(goals);
          callback(null, response);
        })
        .catch(err => callback(err));
      return;
    }

    // TODO: update endpoint to take a day query string for 'today'
    // search by user_uid, returning only completions for the current day
    if (queryStringParameters.user_uid !== undefined) {
      knex.from('completedgoals')
        .join('goals', 'goals.id', 'completedgoals.goal_id')
        .select('goals.id', 'goals.name', 'goals.completed_streak', 'completedgoals.created_at')
        .where({'goals.user_uid': queryStringParameters.user_uid})
        .andWhere(knex.raw('completedgoals.created_at >= CURRENT_DATE'))
        .orderBy('goals.id', 'asc')
        .then((goals) => {
          response.body = JSON.stringify(goals);
          callback(null, response);
        })
        .catch(err => callback(err));
      return;
    }
  }


  knex('completedgoals')
    .orderBy('id', 'asc')
    .then((goals) => {
      response.body = JSON.stringify(goals);
      callback(null, response);
    })
    .catch(err => callback(err));
}
