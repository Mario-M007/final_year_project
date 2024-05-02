import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/services/database/restaurant_service.dart';
import 'package:final_year_project/widgets/restaurant_category_widget.dart';
import 'package:final_year_project/widgets/restaurant_card.dart';
import 'package:final_year_project/widgets/top_address_widget.dart';
import 'dart:developer';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _restaurantService = RestaurantService(); // Assuming you have a service
  List<Restaurant> _restaurants = []; // List to store fetched restaurants
  RestaurantCategory? _selectedCategory; // Track selected category

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
      log("Error fetching restaurants: $error");
    }
  }

  List<Restaurant> _filteredRestaurants() {
    if (_selectedCategory == null) {
      return _restaurants.toList()..sort((a, b) => a.name.compareTo(b.name));
    }
    return _restaurants
        .where(
            (restaurant) => restaurant.restaurantCategory == _selectedCategory)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  String categoryIconFor(RestaurantCategory category) {
    switch (category) {
      case RestaurantCategory.american:
        return "🍔";
      case RestaurantCategory.italian:
        return "🍝";
      case RestaurantCategory.asian:
        return "🍣";
      case RestaurantCategory.lebanese:
        return "🧆";
      default:
        return "🍕";
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = _filteredRestaurants();
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: RestaurantCategory.values
                  .map((category) => Builder(
                        builder: (context) {
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding:
                                const EdgeInsetsDirectional.only(end: 10.0),
                            child: RestaurantCategoryWidget(
                              category: category,
                              categoryIcon: categoryIconFor(category),
                              onPressed: () => setState(() {
                                _selectedCategory =
                                    isSelected ? null : category;
                              }),
                              backgroundColor: isSelected
                                  ? const Color(0xFFEA8D1F)
                                  : Colors.white,
                            ),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 18),
            child: Text(
              "Restaurants nearby",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final restaurant in filteredRestaurants)
            RestaurantCard(
              restaurantImgPath:
                  restaurant.imagePath,
              restaurantName: restaurant.name,
              restaurantId: restaurant.id,
            ),
        ],
      ),
    );
  }
}
