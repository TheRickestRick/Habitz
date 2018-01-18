// GET habits/
// get all habits, or filter based on query strings
module.exports.getAll = function (knex, callback, queryStringParameters) {
  const response = {
    statusCode: 200,
    body: null,
  };

  // filter by goal_id
  if (queryStringParameters !== null && queryStringParameters.goal_id) {
    knex('habits')
      .where({ goal_id: queryStringParameters.goal_id })
      .orderBy('id', 'asc')
      .then((habits) => {
        response.body = JSON.stringify(habits);
        callback(null, response);
      })
      .catch(err => callback(err));
    return;
  }

  // filter by user_uid
  if (queryStringParameters !== null && queryStringParameters.user_uid) {
    knex.from('habits').innerJoin('goals', 'habits.goal_id', 'goals.id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak')
      .where({ user_uid: queryStringParameters.user_uid })
      .orderBy('id', 'asc')
      .then((habits) => {
        response.body = JSON.stringify(habits);
        callback(null, response);
      })
      .catch(err => callback(err));
    return;
  }

  // default to returning all
  knex('habits')
    .orderBy('id', 'asc')
    .then((habits) => {
      response.body = JSON.stringify(habits);
      callback(null, response);
    })
    .catch(err => callback(err));
};


// POST habits/
// create a new habit
module.exports.create = function (knex, callback, body) {
  const response = {
    statusCode: 201,
    body: null,
  };

  knex('habits')
    .insert(params(JSON.parse(body)))
    .returning('*')
    .then((habits) => {
      response.body = JSON.stringify(habits[0]);
      callback(null, response);
    })
    .catch(err => callback(err));
};


// GET habits/:id
// get habit by id
module.exports.get = function (knex, callback, habit_id) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('habits')
    .where({ id: habit_id })
    .first()
    .then((habit) => {
      response.body = JSON.stringify(habit);
      callback(null, response);
    })
    .catch(err => callback(err));
};


// PATCH habits/:id
// update habit
module.exports.patch = function (knex, callback, habit_id, body) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('habits')
    .update(params(JSON.parse(body)))
    .where({ id: habit_id })
    .returning('*')
    .then((habits) => {
      response.body = JSON.stringify(habits[0]);
      callback(null, response);
    })
    .catch(err => callback(err));
};


// DELETE habits/:id
// delete habit
module.exports.delete = function (knex, callback, habit_id) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('habits')
    .del()
    .where({ id: habit_id })
    .then(() => {
      callback(null, response);
    })
    .catch(err => callback(err));
};


// ---------- COMPLETIONS ----------
// POST habits/:id/complete
// create a completion
module.exports.complete = function (knex, callback, habit_id) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('completedhabits')
    .insert({ habit_id })
    .returning('*')
    .then((completedhabits) => {
      response.body = JSON.stringify(completedhabits[0]);
      callback(null, response);
    })
    .catch(err => callback(err));
};

// DELETE habits/:id/complete
// deletes a completion for the current day
module.exports.incomplete = function (knex, callback, habit_id) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('completedhabits')
    .del()
    .where({ habit_id: habit_id })
    .andWhere(knex.raw('created_at >= CURRENT_DATE'))
    .then(() => {
      callback(null, response);
    })
    .catch(err => callback(err));
};


function params(body) {
  return {
    name: body.name,
    completed_streak: body.completed_streak,
    goal_id: body.goal_id,
  };
}
