class Food {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory foodCategory;
  List<Addon> availableAddons;
  List<RequiredOptions> requiredOptions;

  Food({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.foodCategory,
    required this.availableAddons,
    required this.requiredOptions,
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

class RequiredOptions {
  String name;
  double price;

  RequiredOptions({
    required this.name,
    required this.price,
  });
}
