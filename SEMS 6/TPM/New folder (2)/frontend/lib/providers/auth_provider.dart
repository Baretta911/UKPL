import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService();
  
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        // Try to get user profile
        final user = await _apiService.getUserProfile();
        _currentUser = user;
        _isLoggedIn = true;
        await DatabaseService.saveUser(user);
      } else {
        // Check if user exists in local storage
        final localUser = DatabaseService.getCurrentUser();
        if (localUser != null) {
          _currentUser = localUser;
          _isLoggedIn = false; // Token expired, need to login again
        }
      }
    } catch (e) {
      // Try to get user from local storage
      final localUser = DatabaseService.getCurrentUser();
      if (localUser != null) {
        _currentUser = localUser;
        _isLoggedIn = false; // Network error, need to login again
      }
    }
    
    _setLoading(false);
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.login(email, password);
      
      if (response['user'] != null) {
        _currentUser = UserModel.fromJson(response['user']);
        _isLoggedIn = true;
        await DatabaseService.saveUser(_currentUser!);
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError('Invalid response from server');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.register(email, password, name);
      
      if (response['message'] != null) {
        // Registration successful, now login
        final loginSuccess = await login(email, password);
        return loginSuccess;
      } else {
        _setError('Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _apiService.logout();
      await DatabaseService.clearUser();
      await DatabaseService.clearCart();
      await DatabaseService.clearFavorites();
      
      _currentUser = null;
      _isLoggedIn = false;
      _clearError();
    } catch (e) {
      print('Logout error: $e');
    }
    
    _setLoading(false);
    notifyListeners();
  }

  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedUser = await _apiService.updateUserProfile(userData);
      _currentUser = updatedUser;
      await DatabaseService.saveUser(updatedUser);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
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
