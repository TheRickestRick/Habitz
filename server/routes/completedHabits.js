const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {

  // search by user_uid, returning only completions for the previous day
  if (req.query.user_uid !== undefined && req.query.day === 'yesterday') {
    knex.from('completedhabits')
      .join('habits', 'habits.id', 'completedhabits.habit_id')
      .join('goals', 'goals.id', 'habits.goal_id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completedhabits.created_at')
      .where({'goals.user_uid': req.query.user_uid})
      .andWhere(knex.raw('completedhabits.created_at >= CURRENT_DATE - 1 and completedhabits.created_at < CURRENT_DATE'))
      .orderBy('habits.id', 'asc')
      .then(habits => {
        res.json(habits)
      })
      .catch(err => next(err))
    return;
  }

  // TODO: update endpoint to take a day query string for 'today'
  // search by user_uid, returning only completions for the current day
  if (req.query.user_uid !== undefined) {
    knex.from('completedhabits')
      .join('habits', 'habits.id', 'completedhabits.habit_id')
      .join('goals', 'goals.id', 'habits.goal_id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completedhabits.created_at')
      .where({'goals.user_uid': req.query.user_uid})
      .andWhere(knex.raw('completedhabits.created_at >= CURRENT_DATE'))
      .orderBy('habits.id', 'asc')
      .then(habits => {
        res.json(habits)
      })
      .catch(err => next(err))
    return;
  }

  // TODO: update endpoint to take a day query string for 'today'
  // search by goal_id, returning only completions for the current day
  if (req.query.goal_id !== undefined) {
    knex.from('completedhabits')
      .join('habits', 'habits.id', 'completedhabits.habit_id')
      .join('goals', 'goals.id', 'habits.goal_id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completedhabits.created_at')
      .where({'goals.id': req.query.goal_id})
      .andWhere(knex.raw('completedhabits.created_at >= CURRENT_DATE'))
      .orderBy('habits.id', 'asc')
      .then(habits => {
        res.json(habits)
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

  knex('completedhabits')
    .orderBy('id', 'asc')
    .then(habits => res.json(habits))
    .catch(err => next(err))
})

module.exports = router
