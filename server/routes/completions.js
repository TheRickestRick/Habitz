const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {

  // search by user_uid, returning only completions for the previous day
  if (req.query.user_uid !== undefined && req.query.day === 'yesterday') {
    knex.from('completions')
      .join('habits', 'habits.id', 'completions.habit_id')
      .join('goals', 'goals.id', 'habits.goal_id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completions.created_at')
      .where({'goals.user_uid': req.query.user_uid})
      .andWhere(knex.raw('completions.created_at >= CURRENT_DATE - 1 and completions.created_at < CURRENT_DATE'))
      .orderBy('habits.id', 'asc')
      .then(habits => {
        res.json(habits)
      })
      .catch(err => next(err))
    return;
  }

  // search by user_uid, returning only completions for the current day
  if (req.query.user_uid !== undefined) {
    knex.from('completions')
      .join('habits', 'habits.id', 'completions.habit_id')
      .join('goals', 'goals.id', 'habits.goal_id')
      .select('habits.id', 'habits.name', 'habits.goal_id', 'habits.completed_streak', 'completions.created_at')
      .where({'goals.user_uid': req.query.user_uid})
      .andWhere(knex.raw('completions.created_at >= CURRENT_DATE'))
      .orderBy('habits.id', 'asc')
      .then(habits => {
        res.json(habits)
      })
      .catch(err => next(err))
    return;
  }

  //TODO - or update endpoint to get all goals completed at CURRENT_DATE - 1


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

  knex('completions')
    .orderBy('id', 'asc')
    .then(completions => res.json(completions))
    .catch(err => next(err))
})

module.exports = router
