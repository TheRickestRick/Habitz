
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('goals').del()
    .then(function () {
      // Inserts seed entries
      return knex('goals').insert([
        {name: 'Be healthier in mind and body', percent_to_complete: 50, user_uid: "FCewGYWopDh31UsekV8gqgD16lq1", "completed_streak": 1},
        {name: 'Focus more on my relationships', percent_to_complete: 75, user_uid: "HHGIegwwDTRgZX1Lami1DyBieAI3", "completed_streak": 3},
        {name: 'Be a better father and husband', percent_to_complete: 100, user_uid: "FCewGYWopDLamWopDh31Useki1DyB", "completed_streak": 56},
        {name: 'Work out more', percent_to_complete: 50, user_uid: "FCewGYWopDh31UsekV8gqgD16lq1", "completed_streak": 0},
        {name: 'Be more creative', percent_to_complete: 50, user_uid: "IegwwDWopDh31TRgWopDh31UsekV8", "completed_streak": 10}
      ]);
    });
};
