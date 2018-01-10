
exports.up = function(knex, Promise) {
  return knex.schema.table('goals', table => {
    table.dropColumn("user_id");
    table.string("user_uid")
      .references("user_uid")
      .inTable('users')
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.table('goals', table => {
    table.dropColumn("user_uid");
    table.integer("user_id")
      .references("id")
      .inTable('users');
  });
};
