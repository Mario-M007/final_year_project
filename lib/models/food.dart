class Food {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory foodCategory;
  List<Addon>? availableAddons;

  Food({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.foodCategory,
    this.availableAddons,
  });
}

enum FoodCategory {
  mains,
  salads,
  sides,
  desserts,
  drinks,
}

class Addon {
  String name;
  double price;

  Addon({
    required this.name,
    required this.price,
  });
}
