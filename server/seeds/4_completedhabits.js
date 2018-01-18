
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('completedhabits').del()
    .then(function () {
      // Inserts seed entries
      return knex('completedhabits').insert([
        {habit_id: 1},
        {habit_id: 2},
        {habit_id: 4},
        {habit_id: 4, created_at: '2018-01-17'},
        {habit_id: 4, created_at: '2018-01-14'}
      ]);
    });
};
