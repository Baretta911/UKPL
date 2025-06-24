import 'package:flutter/material.dart';
import 'package:toko_mainan_flutter/models/product.dart';
import 'package:toko_mainan_flutter/services/product_service.dart';
import 'package:toko_mainan_flutter/config/constants.dart'; // For API_BASE_URL to construct image URLs
import 'package:toko_mainan_flutter/pages/product_detail_page.dart'; // Import ProductDetailPage
import 'package:toko_mainan_flutter/pages/add_edit_product_page.dart';
import 'package:toko_mainan_flutter/services/auth_service.dart'; // Import AuthService

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService(); // Instantiate AuthService
  List<Product> _products = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _userRole; // To store user role

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchUserRole(); // Fetch user role
  }

  Future<void> _fetchUserRole() async {
    final role = await _authService.getUserRole();
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _productService.getAllProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToProductDetail(Product product) async { // Make async
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
    if (result == true) { // If ProductDetailPage popped with true (e.g., after delete/edit)
      _fetchProducts(); // Refresh the product list
    }
  }

  void _navigateToAddEditProductPage({Product? product}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductPage(product: product),
      ),
    );
    if (result == true) {
      _fetchProducts(); // Refresh the product list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toy Catalog'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
                _products = [];
              });
              _fetchProducts();
            },
            tooltip: 'Refresh Products',
          ),
          // TODO: Add admin-only button to add new product if user is admin
        ],
      ),
      body: _buildProductView(),
      floatingActionButton: _userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () => _navigateToAddEditProductPage(),
              tooltip: 'Add Product',
              child: const Icon(Icons.add),
            )
          : null, // Hide FAB if not admin
    );
  }

  Widget _buildProductView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                'Error: $_errorMessage',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _fetchProducts();
                },
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.toys_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text('No toys found at the moment. Check back later!', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 10.0, // Horizontal space between cards
        mainAxisSpacing: 10.0, // Vertical space between cards
        childAspectRatio: 0.75, // Aspect ratio of the cards (width / height)
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        String? imageUrl = product.imageUrl;
        if (imageUrl != null && !imageUrl.startsWith('http')) {
          imageUrl = API_BASE_URL + (imageUrl.startsWith('/') ? imageUrl : '/' + imageUrl);
        }

        return Card(
          elevation: 2.0,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              _navigateToProductDetail(product);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Hero(
                    tag: 'product_image_${product.id}', // Unique tag for Hero animation
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
                            ),
                          ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Rp${product.price.toStringAsFixed(0)}', // Basic currency formatting
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
