
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('users').del()
    .then(function () {
      // Inserts seed entries
      return knex('users').insert([
        {user_uid: 'FCewGYWopDh31UsekV8gqgD16lq1'},
        {user_uid: 'HHGIegwwDTRgZX1Lami1DyBieAI3'},
        {user_uid: 'FCewGYWopDLamWopDh31Useki1DyB'},
        {user_uid: 'IegwwDWopDh31TRgWopDh31UsekV8'}
      ]);
    });
};
