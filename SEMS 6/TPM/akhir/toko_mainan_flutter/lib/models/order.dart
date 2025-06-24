import 'package:toko_mainan_flutter/models/order_item.dart';
import 'package:toko_mainan_flutter/models/user.dart'; // Assuming you might want to link to a User model

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final User? user;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    this.user,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: (map['_id'] ?? map['id'])?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          (map['orderItems'] as List<dynamic>?) // Fallback for 'orderItems'
              ?.map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: map['orderDate'] != null && (map['orderDate'] as String).isNotEmpty
          ? DateTime.parse(map['orderDate'] as String)
          : DateTime.now(),
      status: map['status'] as String? ?? 'Pending',
      user: map['User'] != null && map['User'] is Map<String, dynamic>
          ? User.fromMap(map['User'] as Map<String, dynamic>)
          : (map['user'] != null && map['user'] is Map<String, dynamic> // Fallback for 'user' key (lowercase)
              ? User.fromMap(map['user'] as Map<String, dynamic>)
              : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'user': user?.toMap(),
    };
  }
}
