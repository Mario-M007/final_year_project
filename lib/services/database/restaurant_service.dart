import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/restaurant.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Restaurant>> getRestaurants() async {
    final snapshot = await _firestore.collection('restaurant').get();
    return snapshot.docs.map((doc) => _fromDocument(doc)).toList();
  }

  Restaurant _fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map;
    final String name = data['name'] as String;
    final String imagePath = data['imagePath'] as String;
    return Restaurant(id: doc.id, name: name, imagePath: imagePath);
  }
}
