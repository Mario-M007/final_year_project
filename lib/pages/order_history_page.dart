import 'package:final_year_project/services/database/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _orderService = OrderService();
  List<Map<String, dynamic>> orders = [];
  bool _isLoading = true; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      orders = await _orderService.getOrdersByUserId(userId);
    } else {
      print('Error: User not signed in');
    }
    setState(() {
      _isLoading = false; // Set loading state to false after fetching data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: _isLoading // Check loading state
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData = orders[index];
                    final orderId = orderData['orderId'];
                    final orderTime = orderData['orderTime'].toDate();
                    final totalPrice = orderData['totalPrice'];
                    final basket = orderData['basket'];
                    final restaurantName = orderData['restaurantName'];
                    final isForDelivery = orderData['isForDelivery'];

                    return ListTile(
                      title: Text('Order #$orderId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Restaurant: $restaurantName'),
                          Text('Date: ${formatDate(orderTime)}'),
                          Text(isForDelivery ? 'Delivery' : 'Dine in'),
                          Text('Total: \$${totalPrice.toStringAsFixed(2)}'),
                          const Text('Items:'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: basket.length,
                            itemBuilder: (context, basketIndex) {
                              final basketItem = basket[basketIndex];
                              final foodName = basketItem['foodName'];
                              final quantity = basketItem['quantity'];

                              return Text('- $foodName x $quantity');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  String formatDate(DateTime timestamp) {
    final year = timestamp.year;
    final month = timestamp.month.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');

    return '$day/$month/$year';
  }
}
