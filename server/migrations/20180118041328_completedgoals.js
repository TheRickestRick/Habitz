
exports.up = function(knex, Promise) {
  return knex.schema.createTable('completedgoals', table => {
    table.increments();
    table.integer("goal_id")
      .references("id")
      .inTable('goals')
      .onDelete('CASCADE');
    table.timestamps(true, true);
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTable('completedgoals');
};
