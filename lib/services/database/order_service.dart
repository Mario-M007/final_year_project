import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveOrder(Orders order) async {
    try {
      await _firestore.collection('orders').doc(order.id).set({
        'userId': order.userId,
        'restaurantId': order.restaurantId,
        'totalPrice': order.totalPrice,
        'orderTime': order.orderTime,
        'orderStatus': order.orderStatus.toString(),
        // You may need to adjust this based on your data model
        // For example, you might want to save each basket item separately
        'basket': order.basket.basketItems
            .map((item) => {
                  'foodId': item.food.id,
                  'quantity': item.quantity,
                  // You can save addons and required options similarly
                })
            .toList(),
      });
    } catch (e) {
      // Handle any errors
      print('Error saving order: $e');
      throw e;
    }
  }
}
