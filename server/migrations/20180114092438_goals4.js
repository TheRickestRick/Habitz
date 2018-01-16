
exports.up = function(knex, Promise) {
  return knex.schema.table('goals', table => {
    table.integer("completed_streak")
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.table('goals', table => {
    table.dropColumn("completed_streak");
  });
};
