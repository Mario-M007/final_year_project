import 'package:flutter/material.dart';

class RequiredOptionRadio extends StatelessWidget {
  final String name;
  final double price;
  final bool isSelected;
  final ValueChanged<bool>? onChanged;

  const RequiredOptionRadio({
    super.key,
    required this.name,
    required this.price,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Only call onChanged if the radio button is not already selected
        if (!isSelected) {
          onChanged?.call(true);
        }
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15.0),
            child: Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
                color: isSelected ? Colors.black : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18.0,
                    )
                  : null,
            ),
          ),
          Expanded(child: Text(name)),
          Text(
            price == 0 ? "" : "+\$${price.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }
}
