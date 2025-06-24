import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_mainan_flutter/config/constants.dart';
import 'package:toko_mainan_flutter/models/order.dart';
import 'package:toko_mainan_flutter/models/cart_item.dart';
import 'package:toko_mainan_flutter/services/auth_service.dart';

class OrderService {
  final AuthService _authService = AuthService();

  Future<Order> createOrder(List<CartItem> cartItems, int userId) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final List<Map<String, dynamic>> orderItemsMap = cartItems
        .map((item) => {
              'productId': item.product.id,
              'quantity': item.quantity,
              // Price will be determined by the backend based on current product price
            })
        .toList();

    final response = await http.post(
      Uri.parse('$API_BASE_URL/orders'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-F',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'userId': userId,
        'items': orderItemsMap,
      }),
    );

    if (response.statusCode == 201) {
      return Order.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create order: ${response.statusCode} ${response.body}');
    }
  }

  // Renamed from getOrdersByUserId to getMyOrders
  // Fetches orders for the currently authenticated user
  Future<List<Order>> getMyOrders() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final response = await http.get(
      Uri.parse('$API_BASE_URL/orders'), // Endpoint for fetching user's own orders
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> orderMaps = json.decode(response.body);
      return orderMaps.map((map) => Order.fromMap(map)).toList();
    } else {
      throw Exception('Failed to fetch orders: ${response.statusCode} ${response.body}');
    }
  }

  // Optional: Get a specific order by its ID (if backend supports it)
  Future<Order> getOrderById(int orderId) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final response = await http.get(
      Uri.parse('$API_BASE_URL/orders/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Order.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch order details: ${response.statusCode} ${response.body}');
    }
  }

    // Get all orders (for admin)
  Future<List<Order>> getAllOrders() async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final response = await http.get(
      Uri.parse('$API_BASE_URL/orders'), // Assuming this is the admin endpoint for all orders
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> orderMaps = json.decode(response.body);
      return orderMaps.map((map) => Order.fromMap(map)).toList();
    } else {
      throw Exception('Failed to fetch all orders: ${response.statusCode} ${response.body}');
    }
  }

  // Update order status (for admin)
  Future<Order> updateOrderStatus(int orderId, String status) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final response = await http.put(
      Uri.parse('$API_BASE_URL/orders/$orderId'), // Corrected endpoint
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode == 200) {
      return Order.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update order status: ${response.statusCode} ${response.body}');
    }
  }
}
