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
      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
      onPressed: (){},
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
