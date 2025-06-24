const db = require('../models'); // Import the db object from models/index.js
const Order = db.Order;
const OrderItem = db.OrderItem;
const Product = db.Product;
const sequelize = db.sequelize;

exports.createOrder = async (req, res) => {
    const t = await sequelize.transaction();
    try {
        const { items } = req.body; // items should be an array of { productId, quantity }
        const userId = req.user.id;

        if (!userId) {
            await t.rollback();
            return res.status(401).json({ message: 'User not authenticated' });
        }

        if (!items || items.length === 0) {
            await t.rollback();
            return res.status(400).json({ message: 'Order must contain at least one item' });
        }

        let calculatedTotalAmount = 0;
        const orderItemsDetails = [];

        // First, validate products and calculate total amount
        for (const item of items) {
            const product = await Product.findByPk(item.productId, { transaction: t });
            if (!product) {
                throw new Error(`Product with ID ${item.productId} not found.`);
            }
            if (product.stock < item.quantity) {
                throw new Error(`Not enough stock for product ID ${item.productId}. Available: ${product.stock}, Requested: ${item.quantity}`);
            }
            calculatedTotalAmount += product.price * item.quantity;
            orderItemsDetails.push({
                productId: item.productId,
                quantity: item.quantity,
                price: product.price, // Use current product price
                // Product stock will be updated later
            });
        }

        // Create the order
        const newOrder = await Order.create({
            userId,
            totalAmount: calculatedTotalAmount,
            status: 'pending', // Default status
        }, { transaction: t });

        // Create order items and update product stock
        const createdOrderItemsPromises = orderItemsDetails.map(async (itemDetail) => {
            // Update product stock
            const product = await Product.findByPk(itemDetail.productId, { transaction: t });
            // product is guaranteed to exist from the check above
            const newStock = product.stock - itemDetail.quantity;
            await Product.update({ stock: newStock }, { where: { id: itemDetail.productId }, transaction: t });
            
            return OrderItem.create({
                orderId: newOrder.id,
                productId: itemDetail.productId,
                quantity: itemDetail.quantity,
                price: itemDetail.price, 
            }, { transaction: t });
        });

        const createdOrderItems = await Promise.all(createdOrderItemsPromises);

        await t.commit();

        // Fetch the full order with items to return
        const fullOrder = await Order.findByPk(newOrder.id, {
            include: [{
                model: OrderItem,
                as: 'items', // Ensure this alias matches frontend expectation
                include: [{ model: Product, as: 'product' }]
            }],
        });

        res.status(201).json(fullOrder);

    } catch (error) {
        await t.rollback();
        console.error('Error creating order:', error);
        if (error.message.includes('not found') || error.message.includes('Not enough stock')) {
             return res.status(400).json({ message: error.message }); // 400 for client errors
        }
        res.status(500).json({ message: 'Error creating order', error: error.name === 'SequelizeValidationError' ? error.errors : error.message });
    }
};

exports.getOrderById = async (req, res) => {
    try {
        const order = await Order.findByPk(req.params.id, {
            include: [{
                model: OrderItem,
                as: 'items', // Alias for order items
                include: [{
                    model: Product,
                    as: 'product' // Alias for product within order items
                }]
            },
            {
                model: User, // Include User details
                as: 'User', // Make sure this alias matches your Order model association if defined
                attributes: ['id', 'username', 'email'] // Specify attributes to include
            }
        ]
        });
        if (!order) {
            return res.status(404).json({ message: 'Order not found' });
        }
        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving order', error });
    }
};

exports.getAllOrders = async (req, res) => {
    try {
        const userId = req.user.id;
        const userRole = req.user.role;

        if (!userId) {
            return res.status(401).json({ message: 'User not authenticated' });
        }

        let queryOptions = {
            include: [
                {
                    model: OrderItem,
                    as: 'items',
                    include: [{ model: Product, as: 'product' }]
                },
                {
                    model: User,
                    as: 'User',
                    attributes: ['id', 'username', 'email']
                }
            ],
            order: [['createdAt', 'DESC']] // Default order
        };

        if (userRole !== 'admin') {
            queryOptions.where = { userId };
        }
        // For admin, no where clause on userId, so all orders are fetched

        const orders = await Order.findAll(queryOptions);
        res.status(200).json(orders);
    } catch (error) {
        console.error('Error retrieving orders:', error);
        res.status(500).json({ message: 'Error retrieving orders', error: error.message });
    }
};

exports.updateOrder = async (req, res) => {
    try {
        const [updated] = await Order.update(req.body, {
            where: { id: req.params.id }
        });
        if (!updated) {
            return res.status(404).json({ message: 'Order not found' });
        }
        const updatedOrder = await Order.findByPk(req.params.id);
        res.status(200).json(updatedOrder);
    } catch (error) {
        res.status(500).json({ message: 'Error updating order', error });
    }
};

exports.deleteOrder = async (req, res) => {
    try {
        const deleted = await Order.destroy({
            where: { id: req.params.id }
        });
        if (!deleted) {
            return res.status(404).json({ message: 'Order not found' });
        }
        res.status(204).send();
    } catch (error) {
        res.status(500).json({ message: 'Error deleting order', error });
    }
};