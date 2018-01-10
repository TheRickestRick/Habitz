
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('habits').del()
    .then(function () {
      // Inserts seed entries
      return knex('habits').insert([
        {name: 'Lift weights', goal_id: 1},
        {name: 'Meditate', goal_id: 1},
        {name: 'Call an old friend', goal_id: 2},
        {name: 'Go to a networking event', goal_id: 3},
        {name: 'Complete one job application', goal_id: 3}
      ]);
    });
};
