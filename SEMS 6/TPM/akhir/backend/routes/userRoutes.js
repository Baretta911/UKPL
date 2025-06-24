const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middlewares/authMiddleware');
const adminMiddleware = require('../middlewares/adminMiddleware'); // Import adminMiddleware

// Route to get user profile
router.get('/profile', authMiddleware.isAuthenticated, userController.getUserProfile);

// Route to update user profile
router.put('/profile', authMiddleware.isAuthenticated, userController.updateUserProfile);

// Route to get all users (admin only)
router.get('/', authMiddleware.isAuthenticated, adminMiddleware.isAdmin, userController.getAllUsers); // Corrected to use adminMiddleware.isAdmin

// Route to delete a user (admin only)
router.delete('/:id', authMiddleware.isAuthenticated, adminMiddleware.isAdmin, userController.deleteUser); // Corrected to use adminMiddleware.isAdmin

module.exports = router;