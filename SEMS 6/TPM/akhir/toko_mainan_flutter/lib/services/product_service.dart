import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:toko_mainan_flutter/config/constants.dart';
import 'package:toko_mainan_flutter/models/product.dart';

class ProductService {
  // Get all products (public route, no auth needed based on your backend routes)
  Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$API_BASE_URL/products'));
    if (response.statusCode == 200) {
      final List<dynamic> productMaps = json.decode(response.body);
      return productMaps.map((map) => Product.fromMap(map)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode} ${response.body}');
    }
  }

  // Get product by ID (public route)
  Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$API_BASE_URL/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to load product: ${response.statusCode} ${response.body}');
    }
  }

  // Create a new product (admin only - requires auth and admin role)
  // This will require handling multipart request for image upload
  Future<Product> createProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required File imageFile,
    required Map<String, String> headers,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$API_BASE_URL/products'),
    );
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['stock'] = stock.toString();
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.headers.addAll(headers); // Add authentication headers

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Product.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to create product: ${response.statusCode} ${response.body}');
    }
  }

  // Update a product (admin only)
  Future<Product> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required int stock,
    File? imageFile, // Image is optional for update
    required Map<String, String> headers,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$API_BASE_URL/products/$id'),
    );
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price.toString();
    request.fields['stock'] = stock.toString();
    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }
    request.headers.addAll(headers); // Add authentication headers

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return Product.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to update product: ${response.statusCode} ${response.body}');
    }
  }

  // Delete a product (admin only)
  Future<void> deleteProduct(int id, Map<String, String> headers) async {
    final response = await http.delete(
      Uri.parse('$API_BASE_URL/products/$id'),
      headers: headers, // Pass authentication headers
    );
    if (response.statusCode != 200 && response.statusCode != 204) { // 204 No Content is also a success for delete
      throw Exception('Failed to delete product: ${response.statusCode} ${response.body}');
    }
  }
}
