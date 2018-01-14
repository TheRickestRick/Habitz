
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('habits').del()
    .then(function () {
      // Inserts seed entries
      return knex('habits').insert([
        {id: 1, name: 'Lift weights', goal_id: 1, completed_streak: 4},
        {id: 2, name: 'Meditate', goal_id: 1, completed_streak: 1},
        {id: 3, name: 'Call an old friend', goal_id: 2, completed_streak: 0},
        {id: 4, name: 'Go to a networking event', goal_id: 3, completed_streak: 14},
        {id: 5, name: 'Complete one job application', goal_id: 3, completed_streak: 3}
      ]);
    });
};
