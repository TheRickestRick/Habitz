const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {
  // query string to search by user_uid
  if (req.query.user_uid !== undefined) {
    knex('completions')
      .where({user_uid: req.query.user_uid})
      .then(goals => res.json(goals))
      .catch(err => next(err))
    return;
  }

  // return only completions for the current date
  if (req.query.today === 'true') {
    console.log('get all completions for current date');
    knex('completions')
      .orderBy('id', 'asc')
      .where(knex.raw('created_at >= CURRENT_DATE'))
      .then(completions => res.json(completions))
      .catch(err => next(err))
    return;
  }

  knex('completions')
    .orderBy('id', 'asc')
    .then(completions => res.json(completions))
    .catch(err => next(err))
})

router.delete('/:id', (req, res, next) => {
  knex('completions')
    .del()
    .where({id: req.params.id})
    .then(() => res.end())
    .catch(err => next(err))
})


module.exports = router
