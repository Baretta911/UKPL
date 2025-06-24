import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/user.dart'; // Assuming User model might be part of Order
import '../services/order_service.dart';
import '../config/constants.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  const OrderDetailPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<Order?> _orderFuture;
  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _orderFuture = _orderService.getOrderById(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<Order?>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Order not found.'));
          }

          final order = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Order Information'),
                _buildInfoRow('Order ID:', order.id),
                _buildInfoRow('Date:', DateFormat('yyyy-MM-dd HH:mm').format(order.orderDate)),
                _buildInfoRow('Status:', order.status),
                _buildInfoRow('Total Amount:', 'Rp${NumberFormat('#,##0', 'id_ID').format(order.totalAmount)}'),
                
                if (order.user != null) ...[
                  const SizedBox(height: 16),
                  _buildSectionTitle('User Information'),
                  _buildInfoRow('Name:', order.user!.name),
                  _buildInfoRow('Email:', order.user!.email),
                ],

                const SizedBox(height: 16),
                _buildSectionTitle('Order Items'),
                if (order.items.isEmpty)
                  const Text('No items in this order.')
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: item.product?.imageUrl != null
                              ? Image.network(
                                  item.product!.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50),
                                )
                              : const Icon(Icons.shopping_bag, size: 50),
                          title: Text(item.product?.name ?? 'Product Name Unavailable'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${item.quantity}'),
                              Text('Price: Rp${NumberFormat('#,##0', 'id_ID').format(item.price)}'),
                            ],
                          ),
                          trailing: Text('Subtotal: Rp${NumberFormat('#,##0', 'id_ID').format(item.price * item.quantity)}'),
                        ),
                      );
                    },
                  ),
                // Add more details as needed, e.g., shipping address
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
