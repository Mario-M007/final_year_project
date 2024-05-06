import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/food.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all foods for a specific restaurant
  Future<List<Food>> getFoodsByRestaurantId(String restaurantId) async {
    final snapshot = await _firestore
        .collection('food')
        .where('restaurantId', isEqualTo: restaurantId)
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
    final List<RequiredOption> requiredOptions =
        (data['requiredOptions'] as List)
            .map(
              (requiredOption) => RequiredOption(
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
}
