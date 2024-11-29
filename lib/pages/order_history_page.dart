import 'dart:developer';

import 'package:final_year_project/models/order.dart';
import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/services/database/order_service.dart';
import 'package:final_year_project/services/database/restaurant_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _orderService = OrderService();
  final _restaurantService = RestaurantService();
  List<Orders> orders = [];
  List<Restaurant> restaurants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      orders = await _orderService.getOrdersByUserId(userId);
      restaurants = await _restaurantService.getRestaurants();
    } else {
      log('Error: User not signed in');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final orderId = order.id;
                    final orderTime = order.orderTime;
                    final totalPrice = order.totalPrice;
                    final basket = order.basket;
                    final restaurant = restaurants.firstWhere(
                      (restaurant) => restaurant.id == order.restaurantId,
                      orElse: () => Restaurant(
                        id: '',
                        name: 'Unknown Restaurant',
                        imagePath: '',
                        restaurantCategory: RestaurantCategory.american,
                        latitude: 0,
                        longitude: 0,
                      ),
                    );
                    final restaurantName = restaurant.name;
                    final isForDelivery = order.isForDelivery;

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
                            itemCount: basket.basketItems.length,
                            itemBuilder: (context, basketIndex) {
                              final basketItem =
                                  basket.basketItems[basketIndex];
                              final foodName = basketItem.food.name;
                              final quantity = basketItem.quantity;
                              final selectedAddons = basketItem.selectedAddons;
                              final selectedRequiredOption =
                                  basketItem.selectedRequiredOption;

                              String addonsText = '';
                              if (selectedAddons != null &&
                                  selectedAddons.isNotEmpty) {
                                addonsText = 'Addons: ';
                                for (final addon in selectedAddons) {
                                  addonsText += '${addon.name}, ';
                                }
                                addonsText = addonsText.substring(
                                    0, addonsText.length - 2);
                              }

                              String requiredOptionText = '';
                              if (selectedRequiredOption != null) {
                                requiredOptionText =
                                    'Option: ${selectedRequiredOption.name}';
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('- $foodName x $quantity'),
                                  if (addonsText.isNotEmpty) Text(addonsText),
                                  if (requiredOptionText.isNotEmpty)
                                    Text(requiredOptionText),
                                ],
                              );
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
