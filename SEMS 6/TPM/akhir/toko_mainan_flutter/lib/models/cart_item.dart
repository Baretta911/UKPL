import 'package:toko_mainan_flutter/models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  // It might be useful to have toMap and fromMap if we decide to persist the cart later
  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productName': product.name, // Storing some product details for easier display
      'productPrice': product.price,
      'productImageUrl': product.imageUrl,
      'quantity': quantity,
    };
  }

  // Example fromMap (adjust if structure from persistence differs)
  // factory CartItem.fromMap(Map<String, dynamic> map, Product product) {
  //   return CartItem(
  //     product: product,
  //     quantity: map['quantity'] as int,
  //   );
  // }
}
