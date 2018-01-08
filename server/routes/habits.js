const express = require('express')
const router = express.Router()
const knex = require('../db')

router.get('/', (req, res, next) => {
  res.send('get all habits');
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
  res.send('create a new habit');
  // knex('posts')
  //   .insert(params(req))
  //   .returning('*')
  //   .then(posts => res.json(posts[0]))
  //   .catch(err => next(err))
})

router.get('/:id', (req, res, next) => {
  res.send(`get habit with id of ${req.params.id}`);
  // knex('posts')
  //   .where({id: req.params.id})
  //   .first()
  //   .then(post => res.json(post))
  //   .catch(err => next(err))
})

router.patch('/:id', validate, (req, res, next) => {
  res.send(`update habit with id of ${req.params.id}`);
  // knex('posts')
  //   .update(params(req))
  //   .where({id: req.params.id})
  //   .returning('*')
  //   .then(posts => res.json(posts[0]))
  //   .catch(err => next(err))
})

router.delete('/:id', (req, res, next) => {
  res.send(`delete habit with id of ${req.params.id}`);
  // knex('posts')
  //   .del()
  //   .where({id: req.params.id})
  //   .then(() => res.end())
  //   .catch(err => next(err))
})

// function params(req) {
//   return {
//     title: req.body.title,
//     body: req.body.body,
//     author: req.body.author,
//     image_url: req.body.image_url,
//   }
// }
//
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
