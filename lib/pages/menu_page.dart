import 'package:final_year_project/models/food.dart';
import 'package:final_year_project/services/database/food_service.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final FoodService _foodService = FoodService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Food>>(
          future: _foodService.getFoods().then((snapshots) => snapshots
              .map((snapshot) => snapshot as Map<String, dynamic>)
              .toList()
              .map((data) => Food.fromMap(data))
              .toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Process snapshot.data to display food items
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Food foodSnapshot = snapshot.data![index];
                  // Get the data map from the DocumentSnapshot
                  Map<String, dynamic> foodData =
                      foodSnapshot as Map<String, dynamic>;
        
                  return ListTile(
                    title: Row(
                      children: [
                        Text(foodData['name']),
                        Text('Price: \$' + snapshot.data![index].price.toString()), 
                      ],
                    ),
                    subtitle: Text(foodData['description']),
                    // Display other food properties based on foodData
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
