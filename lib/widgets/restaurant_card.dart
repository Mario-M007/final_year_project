import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String restaurantImgPath;
  final String restaurantName;

  const RestaurantCard({
    Key? key,
    required this.restaurantImgPath,
    required this.restaurantName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
      onPressed: () => print(restaurantName),
      child: Container(
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
