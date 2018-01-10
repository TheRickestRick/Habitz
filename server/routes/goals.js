const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {
  // query string to search by user_id
  if (req.query.user_id !== undefined) {
    knex('goals')
      .where({user_id: req.query.user_id})
      .then(goals => res.json(goals))
      .catch(err => next(err))
    return;
  }

  knex('goals')
    .then(goals => res.json(goals))
    .catch(err => next(err))
})

router.post('/', validate, (req, res, next) => {
  knex('goals')
    .insert(params(req))
    .returning('*')
    .then(goals => res.json(goals[0]))
    .catch(err => next(err))
})

router.get('/:id', (req, res, next) => {
  knex('goals')
    .where({id: req.params.id})
    .first()
    .then(goal => res.json(goal))
    .catch(err => next(err))
})

router.patch('/:id', validate, (req, res, next) => {
  knex('goals')
    .update(params(req))
    .where({id: req.params.id})
    .returning('*')
    .then(goals => res.json(goals[0]))
    .catch(err => next(err))
})

router.delete('/:id', (req, res, next) => {
  knex('goals')
    .del()
    .where({id: req.params.id})
    .then(() => res.end())
    .catch(err => next(err))
})

function params(req) {
  return {
    name: req.body.name,
    percent_to_complete: req.body.percent_to_complete,
    user_id: req.body.user_id
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
