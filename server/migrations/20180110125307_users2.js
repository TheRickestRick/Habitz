
exports.up = function(knex, Promise) {
  return knex.schema.table('users', table => {
    table.dropColumn("username");
    table.dropColumn("hashed_password");
    table.string("user_uid").unique().notNullable();
  });

};

exports.down = function(knex, Promise) {
  return knex.schema.table('users', table => {
    table.string("username").defaultTo("").notNullable();
    table.string("hashed_password").defaultTo("").notNullable();
    table.dropColumn("user_uid");
  });
};
