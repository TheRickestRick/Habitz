
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('completedgoals').del()
    .then(function () {
      // Inserts seed entries
      return knex('completedgoals').insert([
        {goal_id: 1},
        {goal_id: 2},
        {goal_id: 3},
        {goal_id: 1, created_at: '2018-01-17'},
        {goal_id: 1, created_at: '2018-01-15'},
      ]);
    });
};
