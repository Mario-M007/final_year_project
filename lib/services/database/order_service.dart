import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/food.dart';
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
      log('Error saving order: $e');
    }
  }

  Future<List<Orders>> getOrdersByUserId(String userId) async {
    try {
      final orderQuery = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('orderTime', descending: true)
          .get();

      if (orderQuery.docs.isEmpty) {
        return []; // Return empty list if no orders found
      }

      final List<Orders> orders = [];

      for (var orderDoc in orderQuery.docs) {
        final orderId = orderDoc.id;
        final restaurantId = orderDoc['restaurantId'];

        final basketItems = (orderDoc['basket'] as List)
            .map((item) => BasketItem(
                  food: Food(
                    id: item['foodId'],
                    name: item['foodName'],
                    restaurantId: restaurantId,
                    description: '',
                    imagePath: '',
                    price: 0,
                    foodCategory: FoodCategory.mains,
                    availableAddons: [],
                    requiredOptions: [],
                  ),
                  quantity: item['quantity'],
                  selectedAddons: (item['selectedAddons'] as List?)
                      ?.map((addon) => Addon(
                            name: addon['addonName'],
                            price: addon['addonPrice'],
                          ))
                      .toList(),
                  selectedRequiredOption: item['selectedRequiredOption'] != null
                      ? RequiredOption(
                          name: item['selectedRequiredOption']['optionName'],
                          price: item['selectedRequiredOption']['optionPrice'],
                        )
                      : null,
                ))
            .toList();

        final order = Orders(
          id: orderId,
          userId: userId,
          restaurantId: restaurantId,
          totalPrice: orderDoc['totalPrice'],
          orderTime: orderDoc['orderTime'].toDate(),
          orderStatus: OrderStatus.values.firstWhere(
              (status) => status.toString() == orderDoc['orderStatus']),
          isForDelivery: orderDoc['isForDelivery'],
          basket: Basket(basketItems: basketItems),
        );

        orders.add(order);
      }

      return orders;
    } catch (e) {
      log('Error getting orders for user: $e');
      rethrow;
    }
  }
}
