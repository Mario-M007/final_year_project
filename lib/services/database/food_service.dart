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
        .map(
          (addon) => Addon(
            name: addon['name'],
            price: double.parse(
              addon['price'].toString(),
            ),
          ),
        )
        .toList();
    final List<RequiredOptions> requiredOptions =
        (data['requiredOptions'] as List)
            .map(
              (requiredOption) => RequiredOptions(
                name: requiredOption['name'],
                price: double.parse(
                  requiredOption['price'].toString(),
                ),
              ),
            )
            .toList();

    return Food(
      id: doc.id.toString(),
      restaurantId: data['restaurantId'].toString(),
      name: data['name'].toString(),
      description: data['description'].toString(),
      imagePath: data['imagePath'].toString(),
      price: double.parse(data['price'].toString()),
      foodCategory: FoodCategory.values.byName(data['foodCategory'].toString()),
      availableAddons: addons,
      requiredOptions: requiredOptions,
    );
  }

  Future<Food?> getFoodById(String foodId) async {
    final reference = _firestore.collection('food').doc(foodId);
    final snapshot = await reference.get();
    if (!snapshot.exists) {
      return null; // Return null if food with the ID doesn't exist
    }
    return _fromDocument(snapshot);
  }

  Future<List<Food>> getFoodsByIds(List<String> foodIds) async {
    // Create a list to store retrieved foods
    final List<Food> retrievedFoods = [];

    // Loop through each food ID
    for (final foodId in foodIds) {
      final food = await getFoodById(foodId);
      if (food != null) {
        retrievedFoods.add(food);
      }
      // Handle case where food with the ID doesn't exist (already handled in getFoodById)
    }

    return retrievedFoods;
  }

  // Get all foods for a specific restaurant
  Future<List<Food>> getFoodsByRestaurantId(String restaurantId) async {
    final snapshot = await _firestore
        .collection('food')
        .where('restaurantId', isEqualTo: restaurantId)
        .get();
    return snapshot.docs.map((doc) => _fromDocument(doc)).toList();
  }
}
