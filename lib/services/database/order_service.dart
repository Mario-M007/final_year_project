import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrder(Orders order) async {
    try {
      await _firestore.collection('orders').doc().set({
        'userId': order.userId,
        'restaurantId': order.restaurantId,
        'totalPrice': order.totalPrice,
        'orderTime': order.orderTime,
        'orderStatus': order.orderStatus.toString(),
        'isForDelivery': order.isForDelivery,
        'basket': order.basket.basketItems
            .map((item) => {
                  'foodId': item.food.id,
                  'foodName': item.food.name,
                  'quantity': item.quantity,
                  // You can save addons and required options similarly
                })
            .toList(),
      });
    } catch (e) {
      print('Error saving order: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    try {
      // Get all orders where userId matches the parameter
      final orderDocs = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      // Check if any orders were found
      if (orderDocs.docs.isEmpty) {
        return []; // Return empty list if no orders found
      }

      // List to store final results
      final List<Map<String, dynamic>> ordersWithRestaurantName = [];

      // Loop through retrieved documents
      for (var doc in orderDocs.docs) {
        final orderId = doc.id;
        final restaurantId = doc['restaurantId'];

        // Get restaurant document using restaurantId
        final restaurantDoc =
            await _firestore.collection('restaurant').doc(restaurantId).get();

        // Check if restaurant document exists
        if (restaurantDoc.exists) {
          final restaurantName = restaurantDoc['name'];

          // Create order data with restaurant name
          final orderData = {
            'orderId': orderId, // Include order ID for potential use
            'orderTime': doc['orderTime'],
            'totalPrice': doc['totalPrice'],
            'basket': doc['basket'],
            'restaurantId': restaurantId,
            'restaurantName': restaurantName,
          };

          ordersWithRestaurantName.add(orderData);
        } else {
          print('Restaurant document not found for ID: $restaurantId');
          // You can decide how to handle missing restaurant data here
        }
      }

      return ordersWithRestaurantName;
    } catch (e) {
      print('Error getting orders for user: $e');
      throw e;
    }
  }
}
