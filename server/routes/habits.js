const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {
  // query string to search by goal_id
  if (req.query.goal_id !== undefined) {
    knex('habits')
      .where({goal_id: req.query.goal_id})
      .then(habits => res.json(habits))
      .catch(err => next(err))
  } else {
    knex('habits')
      .then(habits => res.json(habits))
      .catch(err => next(err))
  }
  // knex('posts')
  //   .then(posts => {
  //     return knex('comments')
  //       .whereIn('post_id', posts.map(p => p.id))
  //       .then((comments) => {
  //         const commentsByPostId = comments.reduce((result, comment) => {
  //           result[comment.post_id] = result[comment.post_id] || []
  //           result[comment.post_id].push(comment)
  //           return result
  //         }, {})
  //         posts.forEach(post => {
  //           post.comments = commentsByPostId[post.id] || []
  //         })
  //         res.json(posts)
  //       })
  //   })
  //   .catch(err => next(err))
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

function params(req) {
  return {
    name: req.body.name,
    is_completed: req.body.is_completed,
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
