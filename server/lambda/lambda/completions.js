module.exports.get = function (knex, callback, queryStringParameters) {
  const response = {
    statusCode: 200,
    body: null,
  };


  if (queryStringParameters !== null) {
    // search by user_uid, returning only completions for the previous day
    if (queryStringParameters.user_uid && queryStringParameters.day === 'yesterday') {
      knex.from('completions')
        .join('habits', 'habits.id', 'completions.habit_id')
        .join('goals', 'goals.id', 'habits.goal_id')
        .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completions.created_at')
        .where({ 'goals.user_uid': queryStringParameters.user_uid })
        .andWhere(knex.raw('completions.created_at >= CURRENT_DATE - 1 and completions.created_at < CURRENT_DATE'))
        .orderBy('habits.id', 'asc')
        .then((habits) => {
          response.body = JSON.stringify(habits);
          callback(null, response);
        })
        .catch(err => callback(err));
      return;
    }

    // TODO: update endpoint to take a day query string for 'today'
    // search by user_uid, returning only completions for the current day
    if (queryStringParameters.user_uid) {
      knex.from('completions')
        .join('habits', 'habits.id', 'completions.habit_id')
        .join('goals', 'goals.id', 'habits.goal_id')
        .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completions.created_at')
        .where({ 'goals.user_uid': queryStringParameters.user_uid })
        .andWhere(knex.raw('completions.created_at >= CURRENT_DATE'))
        .orderBy('habits.id', 'asc')
        .then((habits) => {
          response.body = JSON.stringify(habits);
          callback(null, response);
        })
        .catch(err => callback(err));
      return;
    }
  }

  knex('completions')
    .orderBy('id', 'asc')
    .then((completions) => {
      response.body = JSON.stringify(completions);
      callback(null, response);
    })
    .catch(err => callback(err));
};
