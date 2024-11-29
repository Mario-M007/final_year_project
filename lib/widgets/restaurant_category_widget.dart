import 'package:final_year_project/models/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantCategoryWidget extends StatelessWidget {
  final void Function() onPressed;
  final RestaurantCategory category;
  final String categoryIcon;
  final Color backgroundColor;

  const RestaurantCategoryWidget({
    super.key,
    required this.onPressed,
    required this.category,
    required this.categoryIcon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          backgroundColor,
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        minimumSize: WidgetStateProperty.all(const Size(120.0, 60.0)),
        side: WidgetStateProperty.all(
          const BorderSide(
            color: Color(0xFFDBDBDB),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(categoryIcon),
          Text(category.toString().split('.').last),
        ],
      ),
    );
  }
}
