import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';
import '../models/user.dart';

class UserService {
  Future<User?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId'); // Assuming userId is stored

    if (token == null || userId == null) {
      return null;
    }

    final response = await http.get(
      Uri.parse('$apiBaseUrl/users/$userId'), // Endpoint to get user details
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      // Handle error or return null
      print('Failed to load user profile: ${response.body}');
      return null;
    }
  }

  Future<bool> updateUserProfile(String userId, User user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final response = await http.put(
      Uri.parse('$apiBaseUrl/users/$userId'), // Endpoint to update user
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toMap()), // Send updated user data
    );

    if (response.statusCode == 200) {
      // Optionally, update local user data if needed
      // For example, if the AuthService holds the current user, update it.
      // Or, the page calling this can refresh its user data.
      return true;
    } else {
      print('Failed to update user profile: ${response.body}');
      return false;
    }
  }
}
