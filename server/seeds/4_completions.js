
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('completions').del()
    .then(function () {
      // Inserts seed entries
      return knex('completions').insert([
        {habit_id: 1},
        {habit_id: 2},
        {habit_id: 4},
        {habit_id: 4, created_at: '2018-01-13'}
      ]);
    });
};
