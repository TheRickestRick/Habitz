const express = require('express');
const bodyParser = require('body-parser');

const PORT = process.env.PORT || 3000;

const app = express();

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())


app.use('/api/goals', require('./routes/goals'));
app.use('/api/habits', require('./routes/habits'));
app.use('/api/completions', require('./routes/completions'));


app.get('/', (req, res) => {
  res.send("Hello world");
});

// routes not found
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
})


// internal server errors
app.use((err, req, res, next) => {
  if (err.status) {
    return res
      .status(err.status)
      .set('Content-Type', 'text/plain')
      .send(err.message);
  }
  console.error(err.stack);
  res.sendStatus(500);
});


app.listen(PORT, () => {
  console.log(`listening on port ${PORT}...`);
});

module.exports = app;
