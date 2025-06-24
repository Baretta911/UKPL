import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../config/constants.dart'; // Ensure this import is present for apiBaseUrl
import 'user_service.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  String? _token;
  final UserService _userService = UserService();

  User? get currentUser => _currentUser; // Changed from user to currentUser to match usage
  String? get token => _token;
  bool get isAuthenticated => _token != null && _currentUser != null;

  Future<void> _loadTokenAndUser() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userId = prefs.getString('userId');
    final userName = prefs.getString('userName');
    final userEmail = prefs.getString('userEmail');
    final userRole = prefs.getString('userRole');

    if (_token != null && userId != null) {
      if (_currentUser == null || _currentUser!.id != userId) {
        User? fetchedUser = await _userService.getUserProfile();
        if (fetchedUser != null) {
          _currentUser = fetchedUser;
        } else if (userName != null && userEmail != null && userRole != null) {
          _currentUser = User(
            id: userId, // Already a string from prefs
            name: userName,
            email: userEmail,
            role: userRole,
          );
        }
      }
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        _token = responseData['token'];
        _currentUser = User.fromMap(responseData['user']);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('userId', _currentUser!.id); // id is now String
        await prefs.setString('userName', _currentUser!.name);
        await prefs.setString('userEmail', _currentUser!.email);
        await prefs.setString('userRole', _currentUser!.role);
        
        notifyListeners();
        return true;
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        notifyListeners();
        return true;
      } else {
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    await _loadTokenAndUser();
  }

  Future<void> refreshCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    // final storedUserId = prefs.getString('userId'); // Not directly needed here if _userService.getUserProfile() doesn't require it explicitly

    if (storedToken != null) { // Check only for token, as getUserProfile will use the one from auth header
      _token = storedToken; 
      User? fetchedUser = await _userService.getUserProfile(); // Relies on token being set for auth
      if (fetchedUser != null) {
        _currentUser = fetchedUser;
        await prefs.setString('userId', _currentUser!.id); // Re-save userId in case it changed (unlikely but good practice)
        await prefs.setString('userName', _currentUser!.name);
        await prefs.setString('userEmail', _currentUser!.email);
        await prefs.setString('userRole', _currentUser!.role);
      } else {
        print('Failed to refresh user data, keeping existing data if available.');
      }
    } else {
      _currentUser = null;
      _token = null;
    }
    notifyListeners();
  }

  String? getCurrentUserId() {
    return _currentUser?.id; // id is now String, so this is correct
  }
}
