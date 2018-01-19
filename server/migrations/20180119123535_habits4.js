
exports.up = function(knex, Promise) {
  return knex.schema.table('habits', table => {
    table.string("time_of_day").defaultTo("afternoon");
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.table('habits', table => {
    table.dropColumn("time_of_day");
  });
};
