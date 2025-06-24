import 'package:toko_mainan_flutter/config/constants.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  static String buildFullImageUrl(String? relativePath) {
    if (relativePath == null || relativePath.isEmpty) {
      return ''; // Return empty string or a placeholder image URL
    }
    if (relativePath.startsWith('http://') || relativePath.startsWith('https://')) {
      return relativePath; // Already a full URL
    }
    // Ensure API_BASE_URL doesn't have a trailing slash and relativePath starts with one.
    String baseUrl = API_BASE_URL;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    String path = relativePath;
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return baseUrl + path;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String? ?? 'No Name', // Provide default if null
      description: map['description'] as String? ?? 'No Description', // Provide default if null
      price: (map['price'] as num? ?? 0).toDouble(), // Provide default if null
      stock: map['stock'] as int? ?? 0, // Provide default if null
      imageUrl: buildFullImageUrl(map['imageUrl'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      // When sending to backend, it might expect a relative path or the backend handles it.
      // For simplicity, sending the full URL. Adjust if backend expects relative.
      'imageUrl': imageUrl, 
    };
  }
}
