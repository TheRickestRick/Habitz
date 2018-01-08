
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('habits').del()
    .then(function () {
      // Inserts seed entries
      return knex('habits').insert([
        {name: 'Lift weights', is_completed: true, goal_id: 1},
        {name: 'Meditate', is_completed: false, goal_id: 1},
        {name: 'Call an old friend', is_completed: true, goal_id: 2},
        {name: 'Go to a networking event', is_completed: false, goal_id: 3},
        {name: 'Complete one job application', is_completed: true, goal_id: 3}
      ]);
    });
};
