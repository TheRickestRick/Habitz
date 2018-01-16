
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('users').del()
    .then(function () {
      // Inserts seed entries
      return knex('users').insert([
        {user_uid: 'qFxdg6Ra3AWF7o33TbbaGwG1pXU2'},
        {user_uid: 'jlIosFahjvh9d0P0oJjSIs6ydud2'},
        {user_uid: 'QDwfEF6NXDMgUKPS0uHxlFpLML72'},
        {user_uid: 'R5QaZAzjB1dQcPCPsA5WtleSiKk2'}
      ]);
    });
};
