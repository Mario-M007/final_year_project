import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_year_project/models/food.dart';
import 'package:flutter/material.dart';

class MyTestWidget extends StatefulWidget {
  @override
  _MyTestWidgetState createState() => _MyTestWidgetState();
}

class _MyTestWidgetState extends State<MyTestWidget> {
  final List<Map<String, dynamic>> foodItems = [];

  // Function to save food items in Firestore
  Future<void> saveFoodItems() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('food');
    for (final item in foodItems) {
      await collection.add(item);
    }
  }

  @override
  Future<void> initState() async{
    super.initState();

    // Sample food items as JSON
    final burgers = [
      {
        "name": "Big Mac",
        "description":
            "Two all-beef patties, special sauce, lettuce, cheese, pickles, onions on a sesame seed bun",
        "imagePath": "path/to/big_mac.jpg",
        "price": 5.99,
        "foodCategory": FoodCategory.mains.toString(),
        "availableAddons": [],
        "requiredOptions": [],
      },
      // ... Add similar JSON objects for other burgers
    ];

    final fries = {
      "name": "French Fries",
      "description": "Crispy golden fries",
      "imagePath": "path/to/fries.jpg",
      "price": 2.49,
      "foodCategory": FoodCategory.sides.toString(),
      "availableAddons": [],
      "requiredOptions": [],
    };

    final drinks = [
      {
        "name": "Coca-Cola",
        "description": "Classic Coca-Cola",
        "imagePath": "path/to/coke.jpg",
        "price": 1.99,
        "foodCategory": FoodCategory.drinks.toString(),
        "availableAddons": [],
        "requiredOptions": [],
      },
      // ... Add similar JSON objects for other drinks
    ];

    foodItems.addAll(burgers);
    foodItems.add(fries);
    foodItems.addAll(drinks);

    // Call saveFoodItems function (uncomment when ready)
    await saveFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Items for Firestore'),
      ),
      body: Center(
        child: Text(
          'Food items created as JSON. Uncomment saveFoodItems() to save them in Firestore.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
