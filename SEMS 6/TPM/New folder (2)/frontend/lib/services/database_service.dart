import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';

class DatabaseService {
  static late Box<UserModel> _userBox;
  static late Box<ProductModel> _productBox;
  static late Box<Map> _cartBox;
  static late Box<Map> _favoriteBox;
  static late Box<Map> _historyBox;

  static Future<void> initialize() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductModelAdapter());
    }

    // Open boxes
    _userBox = await Hive.openBox<UserModel>('users');
    _productBox = await Hive.openBox<ProductModel>('products');
    _cartBox = await Hive.openBox<Map>('cart');
    _favoriteBox = await Hive.openBox<Map>('favorites');
    _historyBox = await Hive.openBox<Map>('history');
  }

  // User operations
  static Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }

  static UserModel? getCurrentUser() {
    return _userBox.get('current_user');
  }

  static Future<void> clearUser() async {
    await _userBox.delete('current_user');
  }

  // Product operations
  static Future<void> saveProducts(List<ProductModel> products) async {
    final productMap = {for (var product in products) product.id: product};
    await _productBox.putAll(productMap);
  }

  static Future<void> saveProduct(ProductModel product) async {
    await _productBox.put(product.id, product);
  }

  static ProductModel? getProduct(String id) {
    return _productBox.get(id);
  }

  static List<ProductModel> getAllProducts() {
    return _productBox.values.toList();
  }

  static Future<void> clearProducts() async {
    await _productBox.clear();
  }

  // Cart operations
  static Future<void> addToCart(String productId, int quantity) async {
    final cartItem = {
      'productId': productId,
      'quantity': quantity,
      'addedAt': DateTime.now().toIso8601String(),
    };
    await _cartBox.put(productId, cartItem);
  }

  static Future<void> updateCartItem(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    
    final existing = _cartBox.get(productId);
    if (existing != null) {
      existing['quantity'] = quantity;
      await _cartBox.put(productId, existing);
    }
  }

  static Future<void> removeFromCart(String productId) async {
    await _cartBox.delete(productId);
  }

  static List<Map<String, dynamic>> getCartItems() {
    return _cartBox.values.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  static Future<void> clearCart() async {
    await _cartBox.clear();
  }

  static int getCartItemCount() {
    return _cartBox.values.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  // Favorite operations
  static Future<void> addToFavorites(String productId) async {
    final favoriteItem = {
      'productId': productId,
      'addedAt': DateTime.now().toIso8601String(),
    };
    await _favoriteBox.put(productId, favoriteItem);
  }

  static Future<void> removeFromFavorites(String productId) async {
    await _favoriteBox.delete(productId);
  }

  static bool isFavorite(String productId) {
    return _favoriteBox.containsKey(productId);
  }

  static List<String> getFavoriteProductIds() {
    return _favoriteBox.values.map((item) => item['productId'] as String).toList();
  }

  static Future<void> clearFavorites() async {
    await _favoriteBox.clear();
  }

  // History operations
  static Future<void> addToHistory(Map<String, dynamic> historyItem) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    historyItem['id'] = id;
    historyItem['timestamp'] = DateTime.now().toIso8601String();
    await _historyBox.put(id, historyItem);
  }

  static List<Map<String, dynamic>> getHistory() {
    final history = _historyBox.values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
    
    // Sort by timestamp descending
    history.sort((a, b) => 
        DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    
    return history;
  }

  static Future<void> clearHistory() async {
    await _historyBox.clear();
  }

  // Search history
  static Future<void> addSearchHistory(String query) async {
    final searchItem = {
      'query': query,
      'type': 'search',
      'timestamp': DateTime.now().toIso8601String(),
    };
    await addToHistory(searchItem);
  }

  static List<String> getSearchHistory() {
    return getHistory()
        .where((item) => item['type'] == 'search')
        .map((item) => item['query'] as String)
        .take(10)
        .toList();
  }

  // Purchase history
  static Future<void> addPurchaseHistory(Map<String, dynamic> purchase) async {
    purchase['type'] = 'purchase';
    await addToHistory(purchase);
  }

  static List<Map<String, dynamic>> getPurchaseHistory() {
    return getHistory()
        .where((item) => item['type'] == 'purchase')
        .toList();
  }
}
