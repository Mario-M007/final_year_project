class Restaurant {
  final String id;
  final String name;
  final String imagePath;
  final RestaurantCategory restaurantCategory;

  Restaurant({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.restaurantCategory,
  });
}

enum RestaurantCategory {
  american,
  italian,
  asian,
  libanese,
}
