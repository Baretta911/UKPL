import 'package:toko_mainan_flutter/models/product.dart'; // Assuming Product model might be needed for reference

// This model is based on the assumption that when creating an order,
// you might send a list of items, each with productId, quantity, and price.
// However, your backend Order model has productId, quantity, totalPrice directly on the Order table.
// This OrderItem model is more for a scenario where an Order can have MULTIPLE different products.
// If an Order is always for one product type (but multiple quantity), this might be simpler.
// Let's assume for now the `POST /orders` `items` array in your `requests.rest` is the source of truth for creating orders.

class OrderItem {
  final int? id; // Nullable if creating before sending to backend
  final int productId;
  final int quantity;
  final double price; // Price per unit at the time of order
  final String? productName; // For display purposes
  final String? productImageUrl; // For display purposes

  OrderItem({
    this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    this.productName, // Optional: will be populated from backend or product details
    this.productImageUrl, // Optional: will be populated from backend or product details
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    // Product details might be nested or might need a separate fetch/join in a real scenario
    // For now, assume they might come directly or be part of a Product object within OrderItem from backend
    final productData = map['product'] as Map<String, dynamic>?; // If backend sends nested product

    return OrderItem(
      id: map['id'] as int?,
      productId: map['productId'] as int,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      productName: productData != null ? productData['name'] as String? : map['productName'] as String?,
      productImageUrl: productData != null 
          ? Product.buildFullImageUrl(productData['imageUrl'] as String? ?? '')
          : Product.buildFullImageUrl(map['productImageUrl'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    // This is primarily for sending data to the backend when creating an order
    // The backend expects a list of { productId, quantity }
    return {
      'productId': productId,
      'quantity': quantity,
      // 'price' is usually determined by the backend based on current product price
    };
  }
}
