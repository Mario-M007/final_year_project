import 'package:final_year_project/pages/menu_page.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String restaurantImgPath;
  final String restaurantName;
  final String restaurantId;

  const RestaurantCard({
    super.key,
    required this.restaurantImgPath,
    required this.restaurantName,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuPage(restaurantId:restaurantId)),
        );
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(restaurantImgPath),
              width: 350,
              height: 300,
            ),
            Text(restaurantName),
          ],
        ),
      ),
    );
  }
}
