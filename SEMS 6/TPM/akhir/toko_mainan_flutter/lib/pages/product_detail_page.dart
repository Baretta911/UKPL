import 'package:flutter/material.dart';
import 'package:toko_mainan_flutter/models/product.dart';
import 'package:toko_mainan_flutter/pages/add_edit_product_page.dart';
import 'package:toko_mainan_flutter/services/auth_service.dart';
import 'package:toko_mainan_flutter/services/product_service.dart';
import 'package:provider/provider.dart';
import 'package:toko_mainan_flutter/services/cart_service.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  String? _userRole;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final role = await _authService.getUserRole();
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  void _navigateToEditProductPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductPage(product: widget.product),
      ),
    );
    if (result == true) {
      // If product was successfully edited, you might want to refresh data here
      // For now, just pop back or show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated. Refresh catalog to see changes.')),
      );
      Navigator.of(context).pop(); // Pop back to catalog or previous screen
    }
  }

  Future<void> _deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        final token = await _authService.getToken();
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Authentication error. Please login again.')),
          );
          setState(() { _isLoading = false; });
          // Potentially navigate to login page
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        await _productService.deleteProduct(widget.product.id, {'Authorization': 'Bearer $token'});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
        Navigator.of(context).pop(true); // Pop and indicate success to refresh catalog
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: $e')),
        );
      } finally {
        if (mounted) {
            setState(() {
                _isLoading = false;
            });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false); // Access CartService

    String? imageUrl = widget.product.imageUrl;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = API_BASE_URL + (imageUrl.startsWith('/') ? imageUrl : '/' + imageUrl);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: _userRole == 'admin'
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _navigateToEditProductPage,
                  tooltip: 'Edit Product',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _isLoading ? null : _deleteProduct,
                  tooltip: 'Delete Product',
                ),
              ]
            : [],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (imageUrl != null && imageUrl.isNotEmpty)
              Center(
                child: Hero(
                  tag: 'product_image_${widget.product.id}', // Unique tag for Hero animation
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 250,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                height: 250,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.inventory_2_outlined, size: 100, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Rp${widget.product.price.toStringAsFixed(0)}', // Basic currency formatting
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Stock: ${widget.product.stock > 0 ? widget.product.stock.toString() : "Out of Stock"}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.product.stock > 0 ? Colors.green[700] : Colors.red[700],
                  ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.product.description ?? 'No description available.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15.0),
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton.icon(
                onPressed: widget.product.stock > 0 ? () {
                  cartService.addItem(widget.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.product.name} added to cart'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } : null, // Disable if out of stock
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                ),
              ),
            ),
            // TODO: Add Edit/Delete buttons for Admin users
          ],
        ),
      ),
    );
  }
}
