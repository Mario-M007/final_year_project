class Restaurant {
  final String id;
  final String name;
  final String imagePath;
  final RestaurantCategory restaurantCategory;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.restaurantCategory,
    required this.latitude,
    required this.longitude,
  });
}

enum RestaurantCategory {
  american,
  italian,
  asian,
  lebanese,
}
