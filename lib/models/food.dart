class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory foodCategory;
  List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.foodCategory,
    required this.availableAddons,
  });

  factory Food.fromMap(Map<String, dynamic> data) => Food(
        name: data['name'] as String,
        description: data['description'] as String,
        imagePath: data['imagePath'] as String,
        price: (data['price'] as num).toDouble(),
        foodCategory:
            FoodCategory.values.byName(data['foodCategory'] as String),
        availableAddons: (data['availableAddons'] as List)
            .map((addonData) => Addon.fromMap(addonData))
            .toList(),
      );

}

enum FoodCategory {
  main,
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

  factory Addon.fromMap(Map<String, dynamic> data) => Addon(
        name: data['name'] as String,
        price: (data['price'] as num).toDouble(),
      );
}
