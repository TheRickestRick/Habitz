
exports.seed = function(knex, Promise) {
  // Deletes ALL existing entries
  return knex('goals').del()
    .then(function () {
      // Inserts seed entries
      return knex('goals').insert([
        {name: 'Be healthier in mind and body', percent_to_complete: 50, user_uid: "qFxdg6Ra3AWF7o33TbbaGwG1pXU2", "completed_streak": 1},
        {name: 'Focus more on my relationships', percent_to_complete: 75, user_uid: "jlIosFahjvh9d0P0oJjSIs6ydud2", "completed_streak": 3},
        {name: 'Be a better father and husband', percent_to_complete: 100, user_uid: "qFxdg6Ra3AWF7o33TbbaGwG1pXU2", "completed_streak": 56},
        {name: 'Work out more', percent_to_complete: 50, user_uid: "QDwfEF6NXDMgUKPS0uHxlFpLML72", "completed_streak": 0},
        {name: 'Be more creative', percent_to_complete: 50, user_uid: "qFxdg6Ra3AWF7o33TbbaGwG1pXU2", "completed_streak": 10}
      ]);
    });
};
