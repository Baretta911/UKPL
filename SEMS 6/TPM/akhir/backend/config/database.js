const { Sequelize } = require('sequelize');
require('dotenv').config(); // Ensure dotenv is configured

const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASSWORD, {
  host: process.env.DB_HOST,
  dialect: 'mysql', // Changed dialect to mysql
  dialectModule: require('mysql2'), // Specify mysql2 module
  logging: process.env.NODE_ENV === 'development' ? console.log : false, // Log queries in development
});

const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('Connection to the database has been established successfully.');
  } catch (error) {
    console.error('Unable to connect to the database:', error);
  }
};

testConnection();

module.exports = sequelize;