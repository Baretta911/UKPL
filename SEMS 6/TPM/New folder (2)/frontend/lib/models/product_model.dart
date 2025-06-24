import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double price;

  @HiveField(4)
  int stock;

  @HiveField(5)
  String? imageUrl;

  @HiveField(6)
  String category;

  @HiveField(7)
  String storeLocation;

  @HiveField(8)
  String currency;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  bool isFavorite;

  @HiveField(12)
  double rating;

  @HiveField(13)
  int reviewCount;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.category,
    required this.storeLocation,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'],
      imageUrl: json['imageUrl'],
      category: json['category'] ?? 'Toys',
      storeLocation: json['storeLocation'] ?? 'Indonesia',
      currency: json['currency'] ?? 'IDR',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isFavorite: json['isFavorite'] ?? false,
      rating: double.parse(json['rating']?.toString() ?? '0.0'),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
      'category': category,
      'storeLocation': storeLocation,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    String? category,
    String? storeLocation,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    double? rating,
    int? reviewCount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      storeLocation: storeLocation ?? this.storeLocation,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  String get formattedPrice {
    switch (currency) {
      case 'IDR':
        return 'Rp ${price.toStringAsFixed(0)}';
      case 'USD':
        return '\$${price.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${price.toStringAsFixed(0)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      default:
        return '${price.toStringAsFixed(2)} $currency';
    }
  }
}
