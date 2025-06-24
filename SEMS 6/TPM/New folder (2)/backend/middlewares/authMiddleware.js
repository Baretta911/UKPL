const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const User = require('../models/User'); // Import User model

dotenv.config();

const isAuthenticated = async (req, res, next) => { // Make function async
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Expect "Bearer TOKEN"

    if (!token) {
        return res.status(403).json({ message: 'No token provided. Access requires a Bearer token.' });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await User.findByPk(decoded.id); // Fetch user from DB

        if (!user) {
            return res.status(401).json({ message: 'Unauthorized: User not found' });
        }

        req.user = user; // Attach user object to request
        req.userId = decoded.id; // Keep userId as well if needed elsewhere, though req.user.id is preferred
        next();
    } catch (err) {
        if (err.name === 'TokenExpiredError') {
            return res.status(401).json({ message: 'Unauthorized: Token expired' });
        }
        if (err.name === 'JsonWebTokenError') {
            return res.status(401).json({ message: 'Unauthorized: Invalid token' });
        }
        // For other errors, send a generic server error
        console.error("Error in auth middleware:", err);
        return res.status(500).json({ message: 'Internal server error during authentication' });
    }
};

module.exports = { isAuthenticated }; // Export as an object with isAuthenticated property