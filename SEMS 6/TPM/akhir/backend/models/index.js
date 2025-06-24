const sequelize = require('../config/database'); // Use the configured Sequelize instance
const User = require('./User');
const Product = require('./Product');
const Order = require('./Order');
const OrderItem = require('./OrderItem');

const db = {};

db.sequelize = sequelize;
db.Sequelize = require('sequelize'); // For accessing DataTypes, etc.

// Initialize models (they are already initialized in their respective files)
db.User = User;
db.Product = Product;
db.Order = Order;
db.OrderItem = OrderItem;

// Define associations
// User and Order (One-to-Many)
db.User.hasMany(db.Order, {
  foreignKey: 'userId',
  as: 'orders',
});
db.Order.belongsTo(db.User, {
  foreignKey: 'userId',
  as: 'user',
});

// Order and OrderItem (One-to-Many)
db.Order.hasMany(db.OrderItem, {
  foreignKey: 'orderId',
  as: 'items',
});
db.OrderItem.belongsTo(db.Order, {
  foreignKey: 'orderId',
  as: 'order',
});

// Product and OrderItem (One-to-Many)
// An OrderItem belongs to one Product
db.Product.hasMany(db.OrderItem, {
  foreignKey: 'productId',
  as: 'orderItems'
});
db.OrderItem.belongsTo(db.Product, {
  foreignKey: 'productId',
  as: 'product',
});


// Optional: Sync all models (useful for development, consider migrations for production)
// sequelize.sync({ alter: true }).then(() => { // alter: true tries to update tables without dropping them
//   console.log('Database & tables synchronized');
// }).catch(err => {
//   console.error('Failed to synchronize database:', err);
// });

module.exports = db;