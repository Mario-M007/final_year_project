import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/food.dart';

class FoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all foods
  Future<List<Food>> getFoods() async {
    final foodCollection = _firestore.collection('food');
    final snapshot = await foodCollection.get();

    return snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList();
  }

  // Get food by category
  Future<List<Food>> getFoodsByCategory(FoodCategory category) async {
    final foodCollection = _firestore.collection('food');
    final snapshot = await foodCollection
        .where('foodCategory', isEqualTo: category.name)
        .get();

    return snapshot.docs.map((doc) => Food.fromMap(doc.data())).toList();
  }

  // Get a specific food by ID
  Future<Food?> getFood(String id) async {
    final foodDoc = _firestore.collection('food').doc(id);
    final snapshot = await foodDoc.get();

    if (snapshot.exists) {
      return Food.fromMap(
          snapshot.data() as Map<String, dynamic>); // Cast to non-null
    } else {
      return null;
    }
  }
}

// Assuming your Food class has a fromMap constructor to handle data from Firestore
extension FoodMapper on Food {
  static Food fromMap(Map<String, dynamic> data) => Food(
        name: data['name'] as String,
        description: data['description'] as String,
        imagePath: data['imagePath'] as String,
        price: (data['price'] as double).toDouble(),
        foodCategory:
            FoodCategory.values.byName(data['foodCategory'] as String),
        availableAddons: (data['availableAddons'] as List)
            .map((addonData) => Addon.fromMap(addonData))
            .toList(),
      );
}

// Assuming your Addon class also has a fromMap constructor
extension AddonMapper on Addon {
  static Addon fromMap(Map<String, dynamic> data) => Addon(
        name: data['name'] as String,
        price: (data['price'] as double).toDouble(),
      );
}
