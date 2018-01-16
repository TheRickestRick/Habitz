module.exports.getAll = function (knex, callback, user_uid) {
  const response = {
    statusCode: 200,
    body: null,
  };

  if (user_uid) {
    // if user_uid is present, then filter by that
    knex('goals')
    .where({ user_uid: user_uid })
    .then((goals) => {
      response.body = JSON.stringify(goals);
      callback(null, response);
    })
    .catch(err => callback(err));

  } else {
    // otherwise return all goals
    knex('goals')
      .then((goals) => {
        response.body = JSON.stringify(goals);
        callback(null, response);
      })
      .catch(err => callback(err));
  }
};


module.exports.post = function(knex, callback, body) {
  const response = {
    statusCode: 201,
    body: null,
  };

  knex('goals')
    .insert(params(JSON.parse(body)))
    .returning('*')
    .then(goals => {
      response.body = JSON.stringify(goals[0]);
      callback(null, response);
    })
    .catch(err => callback(err));
}


module.exports.get = function(knex, callback, goal_id) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('goals')
    .where({ id: goal_id })
    .first()
    .then(goal => {
      response.body = JSON.stringify(goal);
      callback(null, response);
    })
    .catch(err => callback(err));
}


module.exports.patch = function(knex, callback, goal_id, params) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('goals')
    .update(params(req))
    .where({ id: req.params.id })
    .returning('*')
    .then(goals => res.json(goals[0]))
    .catch(err => callback(err));
}


module.exports.delete = function(knex, callback, goal_id, params) {
  const response = {
    statusCode: 200,
    body: null,
  };

  knex('goals')
    .del()
    .where({ id: req.params.id })
    .then(() => res.end())
    .catch(err => callback(err));
}

function params(body) {
  return {
    name: body.name,
    percent_to_complete: body.percent_to_complete,
    user_uid: body.user_uid,
  };
}
