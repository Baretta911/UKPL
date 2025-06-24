const express = require('express');
const router = express.Router();
const orderController = require('../controllers/orderController');
const authMiddleware = require('../middlewares/authMiddleware');

// Route to create a new order
router.post('/', authMiddleware.isAuthenticated, orderController.createOrder);

// Route to get order details by ID
router.get('/:id', authMiddleware.isAuthenticated, orderController.getOrderById);

// Route to get all orders for a user
router.get('/', authMiddleware.isAuthenticated, orderController.getAllOrders);

// Route to update an order by ID
router.put('/:id', authMiddleware.isAuthenticated, orderController.updateOrder);

// Route to delete an order by ID
router.delete('/:id', authMiddleware.isAuthenticated, orderController.deleteOrder);

module.exports = router;