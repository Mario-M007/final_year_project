import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoryWidget extends StatelessWidget {
  // final void Function()? onPressed;
  final String category;
  final String categoryIcon;

  const CategoryWidget({
    Key? key,
    // this.onPressed,
    required this.category,
    required this.categoryIcon,
  }) : super(key: key);

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
        minimumSize: MaterialStateProperty.all(Size(120.0, 60.0)),
        side: MaterialStateProperty.all(
          const BorderSide(
            color: Color(0xFFDBDBDB),
            width: 2,
          ),
        ),
      ),
      onPressed: () => print("$category"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${categoryIcon}"),
          Text("${category}"),
        ],
      ),
    );
  }
}
