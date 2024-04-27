import 'package:final_year_project/widgets/bottom_app_bar.dart';
import 'package:final_year_project/widgets/category_widget.dart';
import 'package:final_year_project/widgets/restaurant_card.dart';
import 'package:final_year_project/widgets/top_address_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomAppBar(),
      body: ListView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: TopAddressWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 5, bottom: 18),
            child: Text(
              "Categories",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryWidget(category: "American", categoryIcon: "🍔"),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 15),
                  child:
                      CategoryWidget(category: "Italian", categoryIcon: "🍝"),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 15),
                  child: CategoryWidget(category: "Indian", categoryIcon: "🥘"),
                ),
                CategoryWidget(category: "Lebanese", categoryIcon: "🧆"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 18),
            child: Text(
              "Restaurants nearby",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const RestaurantCard(
              restaurantImgPath: "lib/assets/restaurant1.png",
              restaurantName: "Green Cafe"),
          const RestaurantCard(
              restaurantImgPath: "lib/assets/restaurant1.png",
              restaurantName: "Green Cafe"),
          const RestaurantCard(
              restaurantImgPath: "lib/assets/restaurant1.png",
              restaurantName: "Green Cafe"),
          const RestaurantCard(
              restaurantImgPath: "lib/assets/restaurant1.png",
              restaurantName: "Green Cafe"),
        ],
      ),
    );
  }
}
