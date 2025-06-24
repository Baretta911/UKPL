const express = require('express');
const router = express.Router();
const productController = require('../controllers/productController');
const { isAuthenticated } = require('../middlewares/authMiddleware'); // Import isAuthenticated
const { isAdmin } = require('../middlewares/adminMiddleware'); // Import isAdmin
const upload = require('../middlewares/uploadMiddleware'); // Import upload middleware

// Route to create a new product (admin only)
router.post('/', isAuthenticated, isAdmin, upload.single('productImage'), productController.createProduct);

// Route to get all products (admin only)
router.get('/', isAuthenticated, isAdmin, productController.getAllProducts);

// Route to get a product by ID (admin only)
router.get('/:id', isAuthenticated, isAdmin, productController.getProductById);

// Route to update a product by ID (admin only)
router.put('/:id', isAuthenticated, isAdmin, productController.updateProduct);

// Route to delete a product by ID (admin only)
router.delete('/:id', isAuthenticated, isAdmin, productController.deleteProduct);

module.exports = router;