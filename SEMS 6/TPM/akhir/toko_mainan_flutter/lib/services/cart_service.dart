import 'package:flutter/foundation.dart';
import 'package:toko_mainan_flutter/models/cart_item.dart';
import 'package:toko_mainan_flutter/models/product.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addItem(Product product, {int quantity = 1}) {
    // Check if product already in cart
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // If product exists, increase quantity, but not beyond available stock
      if (_items[index].quantity + quantity <= product.stock) {
        _items[index].quantity += quantity;
      } else {
        // Optionally, set to max stock or show a message
        _items[index].quantity = product.stock;
        // Consider throwing an error or showing a notification to the user
        if (kDebugMode) {
          print('Cannot add more items than available in stock.');
        }
      }
    } else {
      // If product not in cart, add new CartItem, ensuring quantity doesn't exceed stock
      if (quantity <= product.stock) {
        _items.add(CartItem(product: product, quantity: quantity));
      } else {
        _items.add(CartItem(product: product, quantity: product.stock));
        // Consider throwing an error or showing a notification
        if (kDebugMode) {
          print('Cannot add more items than available in stock. Added max available.');
        }
      }
    }
    notifyListeners(); // Notify listeners to update UI
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity > 0 && newQuantity <= _items[index].product.stock) {
        _items[index].quantity = newQuantity;
      } else if (newQuantity <= 0) {
        removeItem(productId); // Remove if quantity is zero or less
      } else if (newQuantity > _items[index].product.stock) {
        _items[index].quantity = _items[index].product.stock; // Set to max stock
        if (kDebugMode) {
          print('Quantity exceeds stock. Set to max available.');
        }
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
