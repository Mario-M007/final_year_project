import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/services/database/restaurant_service.dart';
import 'package:final_year_project/widgets/restaurant_category_widget.dart';
import 'package:final_year_project/widgets/restaurant_card.dart';
import 'package:final_year_project/widgets/top_address_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _restaurantService = RestaurantService(); // Assuming you have a service
  List<Restaurant> _restaurants = []; // List to store fetched restaurants

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  void _fetchRestaurants() async {
    try {
      final restaurants = await _restaurantService.getRestaurants();
      setState(() {
        _restaurants = restaurants;
      });
    } catch (error) {
      print("Error fetching restaurants: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: TopAddressWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 5, bottom: 18),
            child: Text(
              "Categories",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                RestaurantCategoryWidget(
                    category: RestaurantCategory.american, categoryIcon: "🍔"),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child: RestaurantCategoryWidget(
                      category: RestaurantCategory.indian, categoryIcon: "🍝"),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 15),
                  child: RestaurantCategoryWidget(
                      category: RestaurantCategory.italian, categoryIcon: "🥘"),
                ),
                RestaurantCategoryWidget(
                    category: RestaurantCategory.lebanese, categoryIcon: "🧆"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 18),
            child: Text(
              "Restaurants nearby",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final restaurant in _restaurants)
            RestaurantCard(
              restaurantImgPath:
                  restaurant.imagePath, // Assuming imagePath in Restaurant
              restaurantName: restaurant.name,
              restaurantId: restaurant.id,
            ),
        ],
      ),
    );
  }
}
