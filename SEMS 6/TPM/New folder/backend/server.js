const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const db = require('./models'); // Import the db object from models/index.js
const authRoutes = require('./routes/authRoutes');
const productRoutes = require('./routes/productRoutes');
const orderRoutes = require('./routes/orderRoutes');
const userRoutes = require('./routes/userRoutes');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000; // Changed default port to 5000

app.use(cors());
app.use(express.json());

app.use('/uploads', express.static('uploads')); // Serve static files from uploads directory

app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/users', userRoutes);

// Sync database and start server
// The `alter: true` option checks the current state of the table in the database (which columns it has, what are their data types, etc),
// and then performs the necessary changes in the table to make it match the model.
// For production, consider using migrations instead of sync({ alter: true }).
db.sequelize.sync({ alter: true })
  .then(() => {
    console.log('Database synchronized successfully.');
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  })
  .catch((error) => {
    console.error('Unable to synchronize the database:', error);
    process.exit(1); // Exit if database sync fails
  });