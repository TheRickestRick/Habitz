
exports.up = function(knex, Promise) {
  return knex.schema.createTable('habits', table => {
    table.increments();
    table.string("name").notNullable();
    table.boolean("is_completed").defaultTo(false).notNullable();
    table.integer("goal_id")
      .references("id")
      .inTable('goals')
    table.timestamps(true, true);
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTable('habits');
};
