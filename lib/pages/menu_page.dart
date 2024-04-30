import 'package:final_year_project/models/food.dart';
import 'package:final_year_project/pages/menu_item_selection_page.dart';
import 'package:final_year_project/services/database/food_service.dart';
import 'package:final_year_project/widgets/custom_switch.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  const MenuPage({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final foodService = FoodService(); // Create an instance of FoodService
  List<Food> foods = []; // List to store retrieved food data
  bool isLoading = true; // loading state
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

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

  bool isForDelivery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: CustomSwitch(
            leftText: 'pick up',
            rightText: 'delivery',
            value: isForDelivery,
            onChanged: (newValue) {
              setState(() {
                isForDelivery = newValue;
                print(isForDelivery);
              });
            },
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: FoodCategory.values.length,
                itemBuilder: (context, categoryIndex) {
                  final category = FoodCategory.values[categoryIndex];
                  final categoryName = capitalize(FoodCategory
                      .values[categoryIndex]
                      .toString()
                      .split('.')
                      .last); // Get enum value from index and convert to string
                  final categoryFoods = foods
                      .where((food) => food.foodCategory == category)
                      .toList();
                  if (categoryFoods.isEmpty) {
                    return const SizedBox
                        .shrink(); // Skip rendering if no foods in this category
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          categoryName, // Display category name
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryFoods.length,
                        itemBuilder: (context, index) {
                          final food = categoryFoods[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuItemSelectionPage(
                                    menuItemId: food.id,
                                    menuItemRestaurantId: food.restaurantId,
                                    menuItemName: food.name,
                                    menuItemImagePath: food.imagePath,
                                    menuItemDescription: food.description,
                                    menuItemPrice: food.price,
                                    menuItemFoodCategory: food.foodCategory,
                                    menuItemAddons: food.availableAddons,
                                    menuItemRequiredOptions:
                                        food.requiredOptions,
                                       isForDelivery: isForDelivery,
                                  ),
                                ),
                              );
                            },
                            title: Text(food.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("\$${food.price.toStringAsFixed(2)}"),
                                Text(food.description),
                              ],
                            ),
                            trailing: food.imagePath == 'null'
                                ? const SizedBox.shrink()
                                : Image(
                                    image: NetworkImage(food.imagePath),
                                  ),
                          );
                        },
                      ),
                      const Divider(), // Add a divider between categories
                    ],
                  );
                },
              ),
      ),
    );
  }
}
