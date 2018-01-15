const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {
  // query string to search by goal_id
  if (req.query.goal_id !== undefined) {
    knex('habits')
      .where({goal_id: req.query.goal_id})
      .orderBy('id', 'asc')
      .then(habits => res.json(habits))
      .catch(err => next(err))
    return;
  }

  // query string to search by user_uid
  if (req.query.user_uid !== undefined) {
    knex.from('habits').innerJoin('goals', 'habits.goal_id', 'goals.id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak')
      .where({user_uid: req.query.user_uid})
      .orderBy('id', 'asc')
      .then(habits => res.json(habits))
      .catch(err => next(err))
    return;
  }

  knex('habits')
    .orderBy('id', 'asc')
    .then(habits => res.json(habits))
    .catch(err => next(err))
})

router.post('/', validate, (req, res, next) => {
  knex('habits')
    .insert(params(req))
    .returning('*')
    .then(habits => res.json(habits[0]))
    .catch(err => next(err))
})

router.get('/:id', (req, res, next) => {
  knex('habits')
    .where({id: req.params.id})
    .first()
    .then(habit => res.json(habit))
    .catch(err => next(err))
})

router.patch('/:id', validate, (req, res, next) => {
  knex('habits')
    .update(params(req))
    .where({id: req.params.id})
    .returning('*')
    .then(habits => res.json(habits[0]))
    .catch(err => next(err))
})

router.delete('/:id', (req, res, next) => {
  knex('habits')
    .del()
    .where({id: req.params.id})
    .then(() => res.end())
    .catch(err => next(err))
})


// COMPLETIONS
router.post('/:id/complete', (req, res, next) => {
  knex('completions')
    .insert({habit_id: req.params.id})
    .returning('*')
    .then(completions => res.json(completions[0]))
    .catch(err => next(err))
})

router.delete('/:id/complete', (req, res, next) => {
  knex('completions')
    .del()
    .where({habit_id: req.params.id})
    .andWhere(knex.raw('created_at >= CURRENT_DATE'))
    .then(() => res.end())
    .catch(err => next(err))
})


function params(req) {
  return {
    name: req.body.name,
    completed_streak: req.body.completed_streak,
    goal_id: req.body.goal_id
  }
}

function validate(req, res, next) {
  const errors = [];
//   ['title', 'body', 'author', 'image_url'].forEach(field => {
//     if (!req.body[field] || req.body[field].trim() === '') {
//       errors.push({field: field, messages: ["cannot be blank"]})
//     }
//   })
  if (errors.length) return res.status(422).json({errors})
  next()
}

module.exports = router
