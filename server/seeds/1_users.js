
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('users').del()
    .then(function () {
      // Inserts seed entries
      return knex('users').insert([
        {id: 1, username: 'wittrura', hashed_password: "adwqdqwdqwd"},
        {id: 2, username: 'fasty', hashed_password: "qdqwdqwdqwdqw"},
        {id: 3, username: 'ryanw', hashed_password: "drgdrgdrgdrg"},
        {id: 4, username: 'ryan@gmail.com', hashed_password: "drgdrgdrgdrg"}
      ]);
    });
};
