import 'package:final_year_project/models/restaurant.dart';
import 'package:final_year_project/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class TopAddressWidget extends StatelessWidget {
  final List<Restaurant> restaurants;
  final LocationData? userLocation;
  const TopAddressWidget({
    super.key,
    required this.restaurants,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapPage(
              restaurants: restaurants,
              userLocation: userLocation,
            ),
          ),
        );
      },
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Beirut",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Icon(Icons.location_pin),
          ],
        ),
      ),
    );
  }
}
