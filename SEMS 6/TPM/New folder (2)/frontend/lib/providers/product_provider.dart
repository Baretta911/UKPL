import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ProductModel> _products = [];
  List<ProductModel> _searchResults = [];
  List<ProductModel> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentFilter = 'all';
  String _currentSort = 'name';

  List<ProductModel> get products => _products;
  List<ProductModel> get searchResults => _searchResults;
  List<ProductModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentFilter => _currentFilter;
  String get currentSort => _currentSort;

  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = List.from(_products);
    
    // Apply filter
    if (_currentFilter != 'all') {
      filtered = filtered.where((product) => 
          product.category.toLowerCase() == _currentFilter.toLowerCase()).toList();
    }
    
    // Apply sort
    switch (_currentSort) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    
    return filtered;
  }

  ProductProvider() {
    loadProducts();
    loadFavorites();
  }

  Future<void> loadProducts() async {
    _setLoading(true);
    _clearError();

    try {
      // Try to load from API
      final apiProducts = await _apiService.getProducts();
      _products = apiProducts;
      
      // Save to local storage
      await DatabaseService.saveProducts(apiProducts);
    } catch (e) {
      // Load from local storage if API fails
      _products = DatabaseService.getAllProducts();
      
      if (_products.isEmpty) {
        _setError('Failed to load products: $e');
      }
    }

    _setLoading(false);
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      // First try to find in local products
      final localProduct = _products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Product not found locally'),
      );
      return localProduct;
    } catch (e) {
      try {
        // Try to get from API
        final product = await _apiService.getProductById(id);
        await DatabaseService.saveProduct(product);
        return product;
      } catch (apiError) {
        // Try local database
        final localProduct = DatabaseService.getProduct(id);
        if (localProduct != null) {
          return localProduct;
        }
        _setError('Product not found: $apiError');
        return null;
      }
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _setLoading(true);
    _clearError();

    try {
      // Try API search first
      final results = await _apiService.searchProducts(query);
      _searchResults = results;
      
      // Save search to history
      await DatabaseService.addSearchHistory(query);
    } catch (e) {
      // Fallback to local search
      _searchResults = _products.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      if (_searchResults.isEmpty) {
        _setError('No products found for "$query"');
      }
    }

    _setLoading(false);
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSort(String sort) {
    _currentSort = sort;
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    final isFav = DatabaseService.isFavorite(productId);
    
    if (isFav) {
      await DatabaseService.removeFromFavorites(productId);
    } else {
      await DatabaseService.addToFavorites(productId);
    }
    
    // Update product in list
    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _products[productIndex] = _products[productIndex].copyWith(isFavorite: !isFav);
    }
    
    loadFavorites();
  }

  void loadFavorites() {
    final favoriteIds = DatabaseService.getFavoriteProductIds();
    _favorites = _products.where((product) => favoriteIds.contains(product.id)).toList();
    notifyListeners();
  }

  List<String> getProductCategories() {
    final categories = <String>{'all'};
    for (final product in _products) {
      categories.add(product.category);
    }
    return categories.toList()..sort();
  }

  List<ProductModel> getProductsByLocation(String location) {
    return _products.where((product) => product.storeLocation == location).toList();
  }

  List<ProductModel> getRecommendedProducts() {
    // Simple recommendation based on rating and popularity
    final recommended = List<ProductModel>.from(_products);
    recommended.sort((a, b) {
      final scoreA = a.rating * 0.7 + (a.reviewCount / 100) * 0.3;
      final scoreB = b.rating * 0.7 + (b.reviewCount / 100) * 0.3;
      return scoreB.compareTo(scoreA);
    });
    return recommended.take(10).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
