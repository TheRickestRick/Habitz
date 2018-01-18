
exports.up = function(knex, Promise) {
  return Promise.all([
    knex.schema.dropTable('completions'),
    knex.schema.createTable('completedhabits', table => {
      table.increments();
      table.integer("habit_id")
        .references("id")
        .inTable('habits')
        .onDelete('CASCADE');
      table.timestamps(true, true);
    })
  ]);
};

exports.down = function(knex, Promise) {
  return Promise.all([
    knex.schema.dropTable('completedhabits'),
    knex.schema.createTable('completions', table => {
      table.increments();
      table.integer("habit_id")
        .references("id")
        .inTable('habits');
      table.timestamps(true, true);
    })
  ])
};
