import 'package:final_year_project/models/food.dart';

class Restaurant {
  final String name;
  final String imagePath;
  final List<Food> menu;

  Restaurant({
    required this.name,
    required this.imagePath,
    required this.menu,
  });
}