import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/restaurant.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Restaurant>> getRestaurants() async {
    final snapshot = await _firestore.collection('restaurant').get();
    return snapshot.docs.map((doc) => _fromDocument(doc)).toList();
  }

  Future<Restaurant?> getRestaurantById(String restaurantId) async {
    try {
      final snapshot =
          await _firestore.collection('restaurant').doc(restaurantId).get();
      if (snapshot.exists) {
        return _fromDocument(snapshot);
      } else {
        log('Restaurant not found for ID: $restaurantId');
        return null;
      }
    } catch (e) {
      log('Error getting restaurant by ID: $e');
      rethrow;
    }
  }

  Restaurant _fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map;
    final String name = data['name'] as String;
    final String imagePath = data['imagePath'] as String;

    return Restaurant(
      id: doc.id,
      name: name,
      imagePath: imagePath,
      restaurantCategory: RestaurantCategory.values
          .byName(data['restaurantCategory'].toString()),
    );
  }
}
