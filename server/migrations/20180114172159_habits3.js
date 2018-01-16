
exports.up = function(knex, Promise) {
  return knex.schema.table('habits', table => {
    table.integer("completed_streak").defaultTo(0);
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.table('habits', table => {
    table.dropColumn("completed_streak");
  });
};
