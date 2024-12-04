import 'dart:math';

import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/services/database/restaurant_service.dart';
import 'package:final_year_project/services/notification/local_notification_service.dart';
import 'package:final_year_project/widgets/restaurant_category_widget.dart';
import 'package:final_year_project/widgets/restaurant_card.dart';
import 'package:final_year_project/widgets/top_address_widget.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _restaurantService = RestaurantService(); // Assuming you have a service
  List<Restaurant> _restaurants = []; // List to store fetched restaurants
  RestaurantCategory? _selectedCategory; // Track selected category

  Location location = Location();
  LocationData? _locationData;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
    _localNotificationService.initLocalNotification();
    _initializeLocation();
    _startLocationListener();
  }

  void _fetchRestaurants() async {
    try {
      final restaurants = await _restaurantService.getRestaurants();
      setState(() {
        _restaurants = restaurants;
      });
    } catch (error) {
      developer.log("Error fetching restaurants: $error");
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

  Future<void> _initializeLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      _locationData = _locationData;
    });
  }

  final Map<String, bool> _notificationShown = {};
  final Map<String, DateTime> _lastNotificationTime = {};

  void _startLocationListener() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      for (var restaurant in _restaurants) {
        double distanceInMeters = Geolocator.distanceBetween(
          currentLocation.latitude!,
          currentLocation.longitude!,
          restaurant.latitude,
          restaurant.longitude,
        );

        // Check if the user is within 100 meters of the restaurant and if a notification has not been shown yet
        if (distanceInMeters <= 100 &&
            (_notificationShown[restaurant.name] ?? false) == false) {
          DateTime now = DateTime.now();
          DateTime? lastNotification = _lastNotificationTime[restaurant.name];

          // Check if the last notification was shown more than 30 minutes ago
          if (lastNotification == null ||
              now.difference(lastNotification).inMinutes > 30) {
            // Show a local notification with a discount offer
            _localNotificationService.showNotification(
              id: Random().nextInt(1000),
              title: "MenuMate",
              body: "Enjoy a 20% discount only @ ${restaurant.name}",
            );
            // Mark the notification as shown and update the last notification time
            _notificationShown[restaurant.name] = true;
            _lastNotificationTime[restaurant.name] = now;
          }
        }
        // Reset the notification flag if the user is more than 100 meters away from the restaurant
        else if (distanceInMeters > 100) {
          _notificationShown[restaurant.name] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = _filteredRestaurants();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 30),
              child: TopAddressWidget(
                restaurants: _restaurants,
                userLocation: _locationData,
              ),
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
              restaurantImgPath: restaurant.imagePath,
              restaurantName: restaurant.name,
              restaurantId: restaurant.id,
            ),
        ],
      ),
    );
  }
}
