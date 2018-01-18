const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {

  // search by user_uid, returning only completions for the previous day
  if (req.query.user_uid !== undefined && req.query.day === 'yesterday') {
    knex.from('completedgoals')
      .join('goals', 'goals.id', 'completedgoals.goal_id')
      .select('goals.id', 'goals.name', 'goals.completed_streak', 'completedgoals.created_at')
      .where({'goals.user_uid': req.query.user_uid})
      .andWhere(knex.raw('completedgoals.created_at >= CURRENT_DATE - 1 and completedgoals.created_at < CURRENT_DATE'))
      .orderBy('goals.id', 'asc')
      .then(goals => {
        res.json(goals)
      })
      .catch(err => next(err))
    return;
  }

  // TODO: update endpoint to take a day query string for 'today'
  // search by user_uid, returning only completions for the current day
  if (req.query.user_uid !== undefined) {
    knex.from('completedgoals')
      .join('goals', 'goals.id', 'completedgoals.goal_id')
      .select('goals.id', 'goals.name', 'goals.completed_streak', 'completedgoals.created_at')
      .where({'goals.user_uid': req.query.user_uid})
      .andWhere(knex.raw('completedgoals.created_at >= CURRENT_DATE'))
      .orderBy('goals.id', 'asc')
      .then(goals => {
        res.json(goals)
      })
      .catch(err => next(err))
    return;
  }

  // return only completions for the current date
  // if (req.query.today === 'true') {
  //   console.log('get all completions for current date');
  //   knex('completions')
  //     .orderBy('id', 'asc')
  //     .where(knex.raw('created_at >= CURRENT_DATE'))
  //     .then(completions => res.json(completions))
  //     .catch(err => next(err))
  //   return;
  // }

  knex('completedgoals')
    .orderBy('id', 'asc')
    .then(completions => res.json(completions))
    .catch(err => next(err))
})

module.exports = router
