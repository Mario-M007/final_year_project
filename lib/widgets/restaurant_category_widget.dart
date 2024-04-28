import 'package:final_year_project/models/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantCategoryWidget extends StatelessWidget {
  // final void Function()? onPressed;
  final RestaurantCategory category;
  final String categoryIcon;

  const RestaurantCategoryWidget({
    super.key,
    // this.onPressed,
    required this.category,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.white,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        minimumSize: MaterialStateProperty.all(const Size(120.0, 60.0)),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Color(0xFFDBDBDB),
            width: 2,
          ),
        ),
      ),
      onPressed: () {},
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
