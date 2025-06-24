import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_mainan_flutter/services/cart_service.dart';
import 'package:toko_mainan_flutter/models/cart_item.dart';
import 'package:intl/intl.dart'; // For currency formatting
import 'package:toko_mainan_flutter/services/auth_service.dart';
import 'package:toko_mainan_flutter/services/order_service.dart';
import 'package:toko_mainan_flutter/pages/login_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartService.items.isEmpty
                ? const Center(
                    child: Text('Your cart is empty.', style: TextStyle(fontSize: 18)),
                  )
                : ListView.builder(
                    itemCount: cartService.items.length,
                    itemBuilder: (context, index) {
                      final CartItem item = cartService.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: ListTile(
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: item.product.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.product.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.image_not_supported, size: 40),
                          ),
                          title: Text(item.product.name),
                          subtitle: Text(currencyFormatter.format(item.product.price)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: item.quantity > 1
                                    ? () {
                                        cartService.updateQuantity(item.product.id, item.quantity - 1);
                                      }
                                    : null, // Disable if quantity is 1, or handle removal
                              ),
                              Text(item.quantity.toString(), style: const TextStyle(fontSize: 16)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: item.quantity < item.product.stock
                                ? () {
                                    cartService.updateQuantity(item.product.id, item.quantity + 1);
                                  }
                                : null, // Disable if quantity reaches stock limit
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  cartService.removeItem(item.product.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item.product.name} removed from cart.')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (cartService.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(
                        currencyFormatter.format(cartService.totalPrice),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // full width
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: cartService.items.isEmpty ? null : () async {
                      // Proceed to Checkout
                      final authService = Provider.of<AuthService>(context, listen: false);
                      final orderService = Provider.of<OrderService>(context, listen: false);
                      final user = await authService.getCurrentUser();

                      if (user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please login to place an order.')),
                        );
                        // Optionally navigate to login page
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                        return;
                      }

                      try {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(child: CircularProgressIndicator());
                          },
                        );

                        final createdOrder = await orderService.createOrder(cartService.items, user.id);
                        
                        Navigator.of(context).pop(); // Dismiss loading indicator

                        cartService.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order placed successfully! Order ID: ${createdOrder.id}')),
                        );
                        // Navigate to an order confirmation page or profile/orders page
                        // For now, just pop back or go to home
                        Navigator.of(context).pop(); 

                        // TODO: Implement local notification for order success

                      } catch (e) {
                        Navigator.of(context).pop(); // Dismiss loading indicator if it was shown
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to place order: $e')),
                        );
                      }
                    },
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
