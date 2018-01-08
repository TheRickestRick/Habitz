
exports.up = function(knex, Promise) {
  return knex.schema.createTable('goals', table => {
    table.increments();
    table.string("name").notNullable();
    table.integer("percent_to_complete").defaultTo(100).notNullable();
    table.timestamps(true, true);
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTable('goals');
};
