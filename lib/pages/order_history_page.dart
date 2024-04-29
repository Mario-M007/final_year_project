import 'package:final_year_project/services/database/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _orderService =
      OrderService(); // Assuming OrderService provides getOrdersByUserId
  List<Map<String, dynamic>> orders = []; // List to store retrieved orders

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      orders = await _orderService.getOrdersByUserId(userId);
      setState(() {}); // Update UI after fetching orders
    } else {
      print('Error: User not signed in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: orders.isEmpty
          ? Center(child: Text('No orders found'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderData = orders[index];
                // Extract data from orderData map
                final orderId =
                    orderData['orderId']; // Assuming orderId is added
                final orderTime = orderData['orderTime'].toDate();
                final totalPrice = orderData['totalPrice'];
                final basket = orderData['basket'];
                final restaurantName = orderData['restaurantName'];

                return ListTile(
                  title: Text('Order #$orderId'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Restaurant: $restaurantName'),
                      Text('Date: ${formatDate(orderTime)}'),
                      Text('Total: \$$totalPrice'),
                      Text('Items:'),
                      ListView.builder(
                        shrinkWrap:
                            true, // Prevent nested list from overflowing
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling
                        itemCount: basket.length,
                        itemBuilder: (context, basketIndex) {
                          final basketItem = basket[basketIndex];
                          final foodName = basketItem['name'];
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

  // Implement formatDate function to format orderTime as needed (e.g., dd/MM/yyyy)
  String formatDate(DateTime timestamp) {
    final year = timestamp.year;
    final month = timestamp.month.toString().padLeft(2, '0'); // Zero-pad month
    final day = timestamp.day.toString().padLeft(2, '0'); // Zero-pad day

    return '$day/$month/$year'; // Adjust format as needed
  }
}
