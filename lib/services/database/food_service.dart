import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/food.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all foods
  Future<List<Food>> getFoods() async {
    final snapshot = await _firestore.collection('food').get();
    return snapshot.docs.map((doc) => _fromDocument(doc)).toList();
  }

  // Get food by category
  Future<List<Food>> getFoodsByCategory(FoodCategory category) async {
    final snapshot = await _firestore
        .collection('food')
        .where('foodCategory', isEqualTo: category.name)
        .get();
    return snapshot.docs.map((doc) => _fromDocument(doc)).toList();
  }

  // Function to convert Firestore document to Food model
  Food _fromDocument(DocumentSnapshot doc) {
    final data = doc.data()! as Map;
    final List<Addon> addons = (data['availableAddons'] as List)
        .map((addon) => Addon(
            name: addon['name'], price: (addon['price'] as num).toDouble()))
        .toList();

    return Food(
      name: data['name'],
      description: data['description'],
      imagePath: data['imagePath'],
      price: data['price'],
      foodCategory: FoodCategory.values.byName(data['foodCategory']),
      availableAddons: addons,
    );
  }
}
