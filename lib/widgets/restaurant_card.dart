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
          overlayColor: WidgetStateProperty.all(Colors.transparent)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenuPage(
                    restaurantId: restaurantId,
                    restaurantName: restaurantName,
                  )),
        );
      },
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 366,
              height: 311,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFDBDBDB)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: NetworkImage(restaurantImgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(restaurantName),
          ],
        ),
      ),
    );
  }
}
