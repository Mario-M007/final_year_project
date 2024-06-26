import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/pages/menu_page.dart';
import 'package:final_year_project/services/database/restaurant_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _restaurantService = RestaurantService();
  final TextEditingController _controller = TextEditingController();

  List<Restaurant> _allRestaurants = []; // List to store all restaurants
  List<Restaurant> _filteredRestaurants = []; // Filtered results

  @override
  void initState() {
    super.initState();
    try {
      _restaurantService.getRestaurants().then((data) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            _allRestaurants = data;
            // Filter restaurants based on initial query (optional)
            _filteredRestaurants = _allRestaurants
                .where((restaurant) => restaurant.name
                    .toLowerCase()
                    .contains(_controller.text.toLowerCase()))
                .toList();
          });
        }
      });
    } catch (error) {
      log("Error fetching restaurants: $error");
    }
  }

  void _filterRestaurants(String query) {
    _filteredRestaurants = _allRestaurants
        .where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    _filteredRestaurants
        .sort((a, b) => a.name.compareTo(b.name)); // Sort filtered restaurants
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search for a restaurant...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA3A4A4),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFA3A4A4),
                  ),
                  // Set background color here
                  fillColor: const Color(0xFFFAFAFA),
                  filled: true,
                  // Remove border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  // Remove border when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _filterRestaurants(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _filteredRestaurants[index];
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 21.0),
                    child: ListTile(
                      title: Text(restaurant.name),
                      leading: restaurant.imagePath.isNotEmpty
                          ? SizedBox(
                              width: 50,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  restaurant.imagePath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : null, // Handle restaurants without images
                      onTap: () {
                        log('restaurant id : ${restaurant.id}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MenuPage(
                                    restaurantId: restaurant.id,
                                    restaurantName: restaurant.name,
                                  )),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
