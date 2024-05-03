import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyTestWidget extends StatefulWidget {
  const MyTestWidget({super.key});
  @override
  _MyTestWidgetState createState() => _MyTestWidgetState();
}

class _MyTestWidgetState extends State<MyTestWidget> {
  final List<Map<String, dynamic>> foodItems = [];

  // Function to save food items in Firestore
  Future<void> saveFoodItems() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('food');
    for (final item in foodItems) {
      await collection.add(item);
    }
  }

  @override
  void initState() {
    super.initState();

    // Sample food items as JSON
    final mains = [
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Big Mac Meal",
        "description": "Big Mac with fries and drink",
        "imagePath":
            "https://s7d1.scene7.com/is/image/mcdonalds/Header_BigMacCombo_v1_832x472:nutrition-calculator-tile?wid=472&hei=472&dpr=off",
        "price": 5.00,
        "foodCategory": "mains",
        "availableAddons": [
          {"name": "Lettuce", "price": 0.1},
          {"name": "Extra Patty", "price": 1.0},
          {"name": "Pickles", "price": 0.1},
          {"name": "Extra Sauce", "price": 0.2},
          {"name": "Extra Cheese", "price": 0.3},
        ],
        "requiredOptions": [
          {"name": "Regular", "price": 0},
          {"name": "Medium", "price": 0.6},
          {"name": "Large", "price": 1.2},
        ],
      },
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Big Tasty Meal",
        "description": "Big Tasty with fries and drink",
        "imagePath":
            "https://s7d1.scene7.com/is/image/mcdonalds/bigtastymeal:1-3-product-tile-desktop?wid=765&hei=472&dpr=off",
        "price": 6.50,
        "foodCategory": "mains",
        "availableAddons": [
          {"name": "Lettuce", "price": 0.1},
          {"name": "Extra Patty", "price": 1.0},
          {"name": "Pickles", "price": 0.1},
          {"name": "Extra Sauce", "price": 0.2},
          {"name": "Extra Cheese", "price": 0.3},
        ],
        "requiredOptions": [
          {"name": "Regular", "price": 0},
          {"name": "Medium", "price": 0.6},
          {"name": "Large", "price": 1.2},
        ],
      },
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Quarter Pounder Meal",
        "description": "Quarter Pounder with fries and drink",
        "imagePath":
            "https://s7d1.scene7.com/is/image/mcdonalds/DC_202201_8941_EVM_M_QuarterPounderCheese_Coke_Glass_832x472:1-3-product-tile-desktop?wid=765&hei=472&dpr=off",
        "price": 5.10,
        "foodCategory": "mains",
        "availableAddons": [
          {"name": "Lettuce", "price": 0.1},
          {"name": "Extra Patty", "price": 1.0},
          {"name": "Pickles", "price": 0.1},
          {"name": "Extra Sauce", "price": 0.2},
          {"name": "Extra Cheese", "price": 0.3},
        ],
        "requiredOptions": [
          {"name": "Regular", "price": 0},
          {"name": "Medium", "price": 0.6},
          {"name": "Large", "price": 1.2},
        ],
      },
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Chicken Mac Meal",
        "description": "Chicken Mac with fries and drink",
        "imagePath":
            "https://mcdonalds.com.pk/wp-content/uploads/2022/08/03-Chicken-Mac.png",
        "price": 5.00,
        "foodCategory": "mains",
        "availableAddons": [
          {"name": "Lettuce", "price": 0.1},
          {"name": "Extra Patty", "price": 1.0},
          {"name": "Pickles", "price": 0.1},
          {"name": "Extra Sauce", "price": 0.2},
          {"name": "Extra Cheese", "price": 0.3},
        ],
        "requiredOptions": [
          {"name": "Regular", "price": 0},
          {"name": "Medium", "price": 0.6},
          {"name": "Large", "price": 1.2},
        ],
      },
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Grand Chicken Deluxe Meal",
        "description": "Grand Chicken Deluxe with fries and drink",
        "imagePath":
            "https://s7d1.scene7.com/is/image/mcdonalds/grand-chicken-deluxe-meal-om-v3:nutrition-calculator-tile",
        "price": 5.00,
        "foodCategory": "mains",
        "availableAddons": [
          {"name": "Lettuce", "price": 0.1},
          {"name": "Extra Patty", "price": 1.0},
          {"name": "Pickles", "price": 0.1},
          {"name": "Extra Sauce", "price": 0.2},
          {"name": "Extra Cheese", "price": 0.3},
        ],
        "requiredOptions": [
          {"name": "Regular", "price": 0},
          {"name": "Medium", "price": 0.6},
          {"name": "Large", "price": 1.2},
        ],
      },
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Chicken Nuggets Meal",
        "description": "Grand Chicken Deluxe with fries and drink",
        "imagePath":
            "https://s7d1.scene7.com/is/image/mcdonalds/9-spicy-nuggets-meal-riyadh-v1:1-3-product-tile-desktop?wid=829&hei=515&dpr=off",
        "price": 5.00,
        "foodCategory": "mains",
        "availableAddons": [
          {"name": "Extra Ketchup", "price": 0.2},
          {"name": "Extra BBQ", "price": 0.2},
          {"name": "Extra Sweet and Sour Sauce", "price": 0.2},
        ],
        "requiredOptions": [
          {"name": "Regular", "price": 0},
          {"name": "Medium", "price": 0.6},
          {"name": "Large", "price": 1.2},
        ],
      },
      // {
      //   "name": "Salmon Sashimi",
      //   "description": "freshly made sushi",
      //   "imagePath":
      //       "https://123099985.cdn6.editmysite.com/uploads/1/2/3/0/123099985/s747026458228626821_p112_i3_w6720.jpeg?width=2560",
      //   "price": 15.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
      //   "name": "Tuna Sashimi",
      //   "description": "freshly made sushi",
      //   "imagePath":
      //       "https://123099985.cdn6.editmysite.com/uploads/1/2/3/0/123099985/s747026458228626821_p112_i3_w6720.jpeg?width=2560",
      //   "price": 15.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
      //   "name": "Ebi Sashimi",
      //   "description": "freshly made sushi",
      //   "imagePath":
      //       "https://123099985.cdn6.editmysite.com/uploads/1/2/3/0/123099985/s747026458228626821_p112_i3_w6720.jpeg?width=2560",
      //   "price": 15.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
      //   "name": "Unagi Sashimi",
      //   "description": "freshly made sushi",
      //   "imagePath":
      //       "https://123099985.cdn6.editmysite.com/uploads/1/2/3/0/123099985/s747026458228626821_p112_i3_w6720.jpeg?width=2560",
      //   "price": 15.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "nPX8HQBnKdhGGnSPdKWF",
      //   "name": "Yellow tail Sashimi",
      //   "description": "freshly made sushi",
      //   "imagePath":
      //       "https://123099985.cdn6.editmysite.com/uploads/1/2/3/0/123099985/s747026458228626821_p112_i3_w6720.jpeg?width=2560",
      //   "price": 15.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
      //   "name": "Chicken Shawarma",
      //   "description": "Heavenly tase",
      //   "imagePath":
      //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2NrOdOVjtkK95W_eRmKgLGle55eSZGGusGI_fdwNjAQ&s",
      //   "price": 5.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
      //   "name": "Beef Shawarma",
      //   "description": "Heavenly tase",
      //   "imagePath":
      //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2NrOdOVjtkK95W_eRmKgLGle55eSZGGusGI_fdwNjAQ&s",
      //   "price": 5.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "4aDFsIyHCgiAc3vkaKSJ",
      //   "name": "Pepperoni Pizza",
      //   "description": "can't beat the classics",
      //   "imagePath":
      //       "https://www.living-lebanon.com/images/extra_pictures/Don-Baker.jpg",
      //   "price": 20.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
      // {
      //   "restaurantId": "4aDFsIyHCgiAc3vkaKSJ",
      //   "name": "Marguerita Pizza",
      //   "description": "can't beat the classics",
      //   "imagePath":
      //       "https://www.thefreshloaf.com/files/u48327/Pizza-09-01-2014-d-Final-SRGB.jpg",
      //   "price": 20.00,
      //   "foodCategory": "mains",
      //   "availableAddons": [
      //   ],
      //   "requiredOptions": [
      //   ],
      // },
    ];

    // final sides = [
    //   {
    //     "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
    //     "name": "French Fries",
    //     "description": "Crispy golden fries",
    //     "imagePath": "null",
    //     "price": 2.49,
    //     "foodCategory": "sides",
    //     "availableAddons": [],
    //     "requiredOptions": [],
    //   },
    //   {
    //     "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
    //     "name": "4 Piece Nuggets",
    //     "description": "Crispy golden nuggets",
    //     "imagePath": "null",
    //     "price": 2.2,
    //     "foodCategory": "sides",
    //     "availableAddons": [],
    //     "requiredOptions": [],
    //   },
    //   {
    //     "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
    //     "name": "6 Piece Nuggets",
    //     "description": "Crispy golden nuggets",
    //     "imagePath": "null",
    //     "price": 3.2,
    //     "foodCategory": "sides",
    //     "availableAddons": [],
    //     "requiredOptions": [],
    //   },
    //   {
    //     "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
    //     "name": "9 Piece Nuggets",
    //     "description": "Crispy golden nuggets",
    //     "imagePath": "null",
    //     "price": 4.2,
    //     "foodCategory": "sides",
    //     "availableAddons": [],
    //     "requiredOptions": [],
    //   },
    // ];

    // final salads = [
    //   {
    //     "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
    //     "name": "Chicken Caesar Salad",
    //     "description": "A rich salad",
    //     "imagePath":
    //         "https://mcdelivery.mcdonalds.com.lb/lb//static/1713982516422/assets/961/products/1707.png?",
    //     "price": 3.49,
    //     "foodCategory": "salads",
    //     "availableAddons": [],
    //     "requiredOptions": [],
    //   }
    // ];

    // final desserts = [
    //   {
    //     "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
    //     "name": "McFlurry",
    //     "description": "",
    //     "imagePath": "https://mcdelivery.mcdonalds.com.lb/lb//static/1713982516422/assets/961/products/2235.png?",
    //     "price": 2.50,
    //     "foodCategory": "desserts",
    //     "availableAddons": [],
    //     "requiredOptions": [
    //       {"name": "Regular", "price": 0},
    //       {"name": "Oreo", "price": 0},
    //       {"name": "Kit-Kat", "price": 0},
    //     ],
    //   }
    // ];

    final drinks = [
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Coca-Cola",
        "description": "Classic Coca-Cola",
        "imagePath": "null",
        "price": 1.99,
        "foodCategory": "drinks",
        "availableAddons": [],
        "requiredOptions": [],
      },
      {
        "restaurantId": "UdAgmn1IHu3Yfbt7Ayoo",
        "name": "Iced Tea Peach",
        "description": "Refreshing peach Iced Tea",
        "imagePath": "null",
        "price": 1.99,
        "foodCategory": "drinks",
        "availableAddons": [],
        "requiredOptions": [],
      },
    ];

    foodItems.addAll(mains);
    // foodItems.addAll(sides);
    // foodItems.addAll(salads);
    foodItems.addAll(drinks);
    // foodItems.addAll(desserts);

    // Call saveFoodItems function (uncomment when ready)
    saveFoodItems();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Added dummy food data for db',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
