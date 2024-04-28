import 'package:final_year_project/pages/menu_page.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String restaurantImgPath;
  final String restaurantName;

  const RestaurantCard({
    super.key,
    required this.restaurantImgPath,
    required this.restaurantName,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuPage()),
        );
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(restaurantImgPath),
            Text(restaurantName),
          ],
        ),
      ),
    );
  }
}
