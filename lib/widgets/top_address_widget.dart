import 'package:final_year_project/pages/map_page.dart';
import 'package:flutter/material.dart';

class TopAddressWidget extends StatelessWidget {
  const TopAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapPage(),
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
