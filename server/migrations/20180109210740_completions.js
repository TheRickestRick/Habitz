
exports.up = function(knex, Promise) {
  return knex.schema.createTable('completions', table => {
    table.increments();
    table.integer("habit_id")
      .references("id")
      .inTable('habits');
    table.timestamps(true, true);
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTable('completions');
};
