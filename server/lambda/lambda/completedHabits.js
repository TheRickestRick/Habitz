module.exports.get = function (knex, callback, queryStringParameters) {
  const response = {
    statusCode: 200,
    body: null,
  };

  if (queryStringParameters !== null) {
    // search by user_uid, returning only completions for the previous day
    if (queryStringParameters.user_uid && queryStringParameters.day === 'yesterday') {
      knex.from('completedhabits')
        .join('habits', 'habits.id', 'completedhabits.habit_id')
        .join('goals', 'goals.id', 'habits.goal_id')
        .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completedhabits.created_at')
        .where({ 'goals.user_uid': queryStringParameters.user_uid })
        .andWhere(knex.raw('completedhabits.created_at >= CURRENT_DATE - 1 and completions.created_at < CURRENT_DATE'))
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
      knex.from('completedhabits')
        .join('habits', 'habits.id', 'completedhabits.habit_id')
        .join('goals', 'goals.id', 'habits.goal_id')
        .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completedhabits.created_at')
        .where({ 'goals.user_uid': queryStringParameters.user_uid })
        .andWhere(knex.raw('completedhabits.created_at >= CURRENT_DATE'))
        .orderBy('habits.id', 'asc')
        .then((habits) => {
          response.body = JSON.stringify(habits);
          callback(null, response);
        })
        .catch(err => callback(err));
      return;
    }

    // TODO: update endpoint to take a day query string for 'today'
    // search by goal_id, returning only completions for the current day
    if (queryStringParameters.goal_id) {
      knex.from('completedhabits')
        .join('habits', 'habits.id', 'completedhabits.habit_id')
        .join('goals', 'goals.id', 'habits.goal_id')
        .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completedhabits.created_at')
        .where({ 'goals.id': queryStringParameters.goal_id })
        .andWhere(knex.raw('completedhabits.created_at >= CURRENT_DATE'))
        .orderBy('habits.id', 'asc')
        .then((habits) => {
          response.body = JSON.stringify(habits);
          callback(null, response);
        })
        .catch(err => callback(err));
      return;
    }
  }

  knex('completedhabits')
    .orderBy('id', 'asc')
    .then((completions) => {
      response.body = JSON.stringify(completions);
      callback(null, response);
    })
    .catch(err => callback(err));
};
