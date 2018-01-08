
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('goals').del()
    .then(function () {
      // Inserts seed entries
      return knex('goals').insert([
        {name: 'Be healthier in mind and body', percent_to_complete: 50},
        {name: 'Focus more on my relationships', percent_to_complete: 75},
        {name: 'Start a new career in software engineering', percent_to_complete: 100}
      ]);
    });
};
