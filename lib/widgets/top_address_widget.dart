import 'package:flutter/material.dart';

class TopAddressWidget extends StatelessWidget {
  const TopAddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
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
