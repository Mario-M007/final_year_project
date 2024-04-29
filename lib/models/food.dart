class Food {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory foodCategory;
  List<Addon> availableAddons;
  List<RequiredOption> requiredOptions;

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

  @override
  String toString() {
    return 'Food: { id: $id, restaurantId: $restaurantId, name: $name, description: $description, imagePath: $imagePath, price: $price, foodCategory: $foodCategory, availableAddons: $availableAddons, requiredOptions: $requiredOptions }';
  }
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

  @override
  String toString() {
    return 'Addon: { name: $name, price: $price }';
  }
}

class RequiredOption {
  String name;
  double price;

  RequiredOption({
    required this.name,
    required this.price,
  });

  @override
  String toString() {
    return 'RequiredOption: { name: $name, price: $price }';
  }
}
