import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrder(Orders order) async {
  try {
    DocumentReference docRef = _firestore.collection('orders').doc();
    String orderId = docRef.id;

    await docRef.set({
      'orderId': orderId,
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
              })
          .toList(),
    });

    print('Order ID: $orderId');

  } catch (e) {
    print('Error saving order: $e');
    throw e;
  }
}


  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    try {
      // Query orders directly instead of filtering afterwards
      final orderQuery = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderTime',
              descending: true) // Order by time for efficiency
          .get();

      if (orderQuery.docs.isEmpty) {
        return []; // Return empty list if no orders found
      }

      final List<Map<String, dynamic>> ordersWithRestaurantName = [];
      final List<Future<DocumentSnapshot>> restaurantDocsFutures = [];

      // Loop through retrieved documents
      for (var orderDoc in orderQuery.docs) {
        final orderId = orderDoc.id;
        final restaurantId = orderDoc['restaurantId'];
        restaurantDocsFutures
            .add(_firestore.collection('restaurant').doc(restaurantId).get());

        // Create order data without restaurant name for now
        final orderData = {
          'orderId': orderId,
          'orderTime': orderDoc['orderTime'],
          'totalPrice': orderDoc['totalPrice'],
          'basket': orderDoc['basket'],
          'restaurantId': restaurantId,
          'isForDelivery': orderDoc['isForDelivery'],
        };

        ordersWithRestaurantName.add(orderData);
      }

      // Retrieve restaurant documents concurrently
      final restaurantDocs = await Future.wait(restaurantDocsFutures);

      // Loop through retrieved restaurant documents
      for (var i = 0; i < restaurantDocs.length; i++) {
        final restaurantDoc = restaurantDocs[i];
        if (restaurantDoc.exists) {
          final restaurantName = restaurantDoc['name'];
          ordersWithRestaurantName[i]['restaurantName'] = restaurantName;
        } else {
          print(
              'Restaurant document not found for ID: ${orderQuery.docs[i]['restaurantId']}');
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
