const isAdmin = (req, res, next) => {
    // Check if the user has admin privileges
    // Ensure req.user is populated by a preceding auth middleware
    if (req.user && req.user.role === 'admin') {
        next(); // User is an admin, proceed to the next middleware or route handler
    } else {
        // If req.user is not present, it might mean auth middleware didn't run or failed
        if (!req.user) {
            return res.status(401).json({ message: 'Authentication required. Please log in.' });
        }
        // If user is present but not an admin
        res.status(403).json({ message: 'Access denied. Administrator privileges required.' });
    }
};

module.exports = { isAdmin }; // Export as an object with isAdmin property