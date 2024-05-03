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
                  'selectedAddons': item.selectedAddons
                      ?.map((addon) => {
                            'addonName': addon.name,
                            'addonPrice': addon.price,
                          })
                      .toList(),
                  'selectedRequiredOption': item.selectedRequiredOption != null
                      ? {
                          'optionName': item.selectedRequiredOption!.name,
                          'optionPrice': item.selectedRequiredOption!.price,
                        }
                      : null,
                })
            .toList(),
      });
    } catch (e) {
      print('Error saving order: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    try {
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

      final restaurantDocs = await Future.wait(restaurantDocsFutures);

      for (var i = 0; i < restaurantDocs.length; i++) {
        final restaurantDoc = restaurantDocs[i];
        if (restaurantDoc.exists) {
          final restaurantName = restaurantDoc['name'];
          ordersWithRestaurantName[i]['restaurantName'] = restaurantName;
        } else {
          print(
              'Restaurant document not found for ID: ${orderQuery.docs[i]['restaurantId']}');
        }
      }

      return ordersWithRestaurantName;
    } catch (e) {
      print('Error getting orders for user: $e');
      throw e;
    }
  }
}
