
exports.up = function(knex, Promise) {
  return knex.schema.table('habits', table => {
    table.dropColumn("is_completed");
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.table('goals', table => {
    table.boolean("is_completed").defaultTo(false).notNullable();
  });
};
