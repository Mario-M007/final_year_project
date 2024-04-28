import 'package:final_year_project/models/food.dart';
import 'package:final_year_project/services/database/food_service.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  final String restaurantId;
  const MenuPage({
    super.key,
    required this.restaurantId,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final foodService = FoodService(); // Create an instance of FoodService
  List<Food> foods = []; // List to store retrieved food data
  bool isLoading = true; // loading state

  @override
  void initState() {
    super.initState();
    // Fetch food data based on IDs on widget initialization
    foodService.getFoodsByRestaurantId(widget.restaurantId).then((data) {
      setState(() {
        foods = data; // Update state with retrieved food data
        isLoading = false; // data is loaded
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MENU"),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  // Customize the widget based on your Food model properties
                  return Column(
                    children: [
                      Text(food.foodCategory.name),
                      ListTile(
                        onTap: () {},
                        title: Text(food.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "\$${food.price.toStringAsFixed(2)}"), // Format price with 2 decimal places
                            Text(food.description),
                          ],
                        ),
                        trailing: Image(
                          image: NetworkImage(food.imagePath),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
