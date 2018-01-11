const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {
  // query string to search by user_uid
  knex('users')
    .then(users => res.json(users))
    .catch(err => next(err))
})

router.post('/', validate, (req, res, next) => {
  knex('users')
    .insert(params(req))
    .returning('*')
    .then(users => res.json(users[0]))
    .catch(err => next(err))
})

router.get('/:id', (req, res, next) => {
  knex('users')
    .where({id: req.params.id})
    .first()
    .then(goal => res.json(goal))
    .catch(err => next(err))
})

router.patch('/:id', validate, (req, res, next) => {
  knex('users')
    .update(params(req))
    .where({id: req.params.id})
    .returning('*')
    .then(users => res.json(users[0]))
    .catch(err => next(err))
})

router.delete('/:id', (req, res, next) => {
  knex('users')
    .del()
    .where({id: req.params.id})
    .then(() => res.end())
    .catch(err => next(err))
})

function params(req) {
  return {
    user_uid: req.user_uid
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
