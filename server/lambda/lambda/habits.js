module.exports.getAll = function(knex, callback, queryStringParameters) {
  const response = {
    statusCode: 200,
    body: null,
  };

  // query string to search by goal_id
  if (queryStringParameters !== null && queryStringParameters.goal_id) {
    knex('habits')
      .where({goal_id: queryStringParameters.goal_id})
      .orderBy('id', 'asc')
      .then(habits => {
        response.body = JSON.stringify(habits);
        callback(null, response);
      })
      .catch(err => callback(err));
    return;
  }

  // query string to search by user_uid
  if (queryStringParameters !== null && queryStringParameters.user_uid) {
    knex.from('habits').innerJoin('goals', 'habits.goal_id', 'goals.id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak')
      .where({user_uid: queryStringParameters.user_uid})
      .orderBy('id', 'asc')
      .then(habits => {
        response.body = JSON.stringify(habits);
        callback(null, response);
      })
      .catch(err => callback(err));
    return;
  }

  knex('habits')
    .orderBy('id', 'asc')
    .then(habits => {
      response.body = JSON.stringify(habits);
      callback(null, response);
    })
    .catch(err => callback(err));
  return;
}


module.exports.create = function(knex, callback, body) {
  const response = {
    statusCode: 201,
    body: null,
  };

  knex('habits')
    .insert(params(JSON.parse(body)))
    .returning('*')
    .then(habits => {
      response.body = JSON.stringify(habits[0]);
      callback(null, response);
    })
    .catch(err => callback(err));
}


// //TODO
// module.exports.get = function() {}
// router.get('/:id', (req, res, next) => {
//   knex('habits')
//     .where({id: req.params.id})
//     .first()
//     .then(habit => res.json(habit))
//     .catch(err => next(err))
// })
//
//
// //TODO
// module.exports.patch = function() {}
// router.patch('/:id', validate, (req, res, next) => {
//   knex('habits')
//     .update(params(req))
//     .where({id: req.params.id})
//     .returning('*')
//     .then(habits => res.json(habits[0]))
//     .catch(err => next(err))
// })
//
//
// //TODO
// module.exports.delete = function() {}
// router.delete('/:id', (req, res, next) => {
//   knex('habits')
//     .del()
//     .where({id: req.params.id})
//     .then(() => res.end())
//     .catch(err => next(err))
// })
//
//
// // COMPLETIONS
// //TODO
// module.exports.complete = function() {}
// router.post('/:id/complete', (req, res, next) => {
//   knex('completions')
//     .insert({habit_id: req.params.id})
//     .returning('*')
//     .then(completions => res.json(completions[0]))
//     .catch(err => next(err))
// })
//
//
// //TODO
// module.exports.deleteCompletion = function() {}
// router.delete('/:id/complete', (req, res, next) => {
//   knex('completions')
//     .del()
//     .where({habit_id: req.params.id})
//     .andWhere(knex.raw('created_at >= CURRENT_DATE'))
//     .then(() => res.end())
//     .catch(err => next(err))
// })


function params(body) {
  return {
    name: body.name,
    completed_streak: body.completed_streak,
    goal_id: body.goal_id,
  };
}
