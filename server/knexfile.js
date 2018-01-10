module.exports = {

  development: {
    client: 'pg',
    connection: {
      database: process.env.DATABASE_URL || 'habitz_dev',
    }
  },

  test: {
    client: 'pg',
    connection: {
      database: process.env.DATABASE_URL || 'habitz_test',
    }
  },

  production: {
    client: 'pg',
    connection: process.env.DATABASE_URL,
  }

};
