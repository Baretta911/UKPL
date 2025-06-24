# Backend Project

## Overview
This is a Node.js backend project that provides a RESTful API for managing users, products, and orders. It is built using Express.js and utilizes Sequelize for database interactions.

## Directory Structure
```
backend
├── config
│   └── database.js
├── controllers
│   ├── authController.js
│   ├── productController.js
│   ├── orderController.js
│   └── userController.js
├── middlewares
│   ├── authMiddleware.js
│   └── adminMiddleware.js
├── models
│   ├── User.js
│   ├── Product.js
│   ├── Order.js
│   ├── OrderItem.js
│   └── index.js
├── routes
│   ├── authRoutes.js
│   ├── productRoutes.js
│   ├── orderRoutes.js
│   └── userRoutes.js
├── .env
├── package.json
├── server.js
└── README.md
```

## Installation
1. Clone the repository:
   ```
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```
   cd backend
   ```
3. Install the dependencies:
   ```
   npm install
   ```

## Configuration
- Create a `.env` file in the root directory and add your environment variables, such as database connection strings and secret keys.

## Running the Application
To start the server, use the following command:
```
npm run dev
```
This will run the application in development mode using Nodemon.

## API Endpoints
- **Authentication**
  - POST `/api/auth/login`: Log in a user.
  - POST `/api/auth/register`: Register a new user.

- **Products**
  - GET `/api/products`: Retrieve all products.
  - POST `/api/products`: Create a new product.
  - PUT `/api/products/:id`: Update a product.
  - DELETE `/api/products/:id`: Delete a product.

- **Orders**
  - GET `/api/orders`: Retrieve all orders.
  - POST `/api/orders`: Create a new order.

- **Users**
  - GET `/api/users`: Retrieve all users.
  - GET `/api/users/:id`: Retrieve a specific user.

## License
This project is licensed under the ISC License.