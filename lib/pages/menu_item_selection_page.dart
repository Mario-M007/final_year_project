import 'package:final_year_project/models/order.dart';
import 'package:final_year_project/services/database/basket_manager.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/models/food.dart';
import 'package:final_year_project/widgets/main_button.dart';
import 'package:final_year_project/widgets/required_option_radio.dart';
import 'package:final_year_project/widgets/addon_check_box.dart';

class MenuItemSelectionPage extends StatefulWidget {
  final String menuItemId;
  final String menuItemRestaurantId;
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemImagePath;
  final double menuItemPrice;
  final FoodCategory menuItemFoodCategory;
  final List<Addon> menuItemAddons;
  final List<RequiredOption> menuItemRequiredOptions;

  const MenuItemSelectionPage({
    Key? key,
    required this.menuItemId,
    required this.menuItemRestaurantId,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.menuItemImagePath,
    required this.menuItemPrice,
    required this.menuItemFoodCategory,
    required this.menuItemAddons,
    required this.menuItemRequiredOptions,
  }) : super(key: key);

  @override
  State<MenuItemSelectionPage> createState() => _MenuItemSelectionPageState();
}

class _MenuItemSelectionPageState extends State<MenuItemSelectionPage> {
  int quantity = 0;

  List<bool> addonCheckStates = [];
  List<Addon> selectedAddons = [];

  int? selectedRequiredOptionRadio;

  @override
  void initState() {
    super.initState();
    addonCheckStates = List<bool>.filled(widget.menuItemAddons.length, false);
  }

  void toggleAddonCheckbox(int index) {
    setState(() {
      addonCheckStates[index] = !addonCheckStates[index];
      if (addonCheckStates[index]) {
        selectedAddons.add(widget.menuItemAddons[index]);
      } else {
        selectedAddons.remove(widget.menuItemAddons[index]);
      }
    });
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              widget.menuItemImagePath == "null"
                  ? const SizedBox(
                      height: 15,
                    )
                  : Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 15),
                      child: SizedBox(
                        width: 300,
                        height: 150,
                        child: Image(
                          image: NetworkImage(widget.menuItemImagePath),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text(widget.menuItemName,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text("\$${widget.menuItemPrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text(
                  widget.menuItemDescription,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: const Color.fromARGB(255, 139, 139, 139)),
                ),
              ),
              const Divider(
                thickness: 10,
                color: Color(0xFFF6F6F6),
              ),
              Visibility(
                visible: widget.menuItemRequiredOptions.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 25, end: 25, top: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Choose Option",
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                "Required",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: const Color(0xFF6B6B6B),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (int i = 0;
                          i < widget.menuItemRequiredOptions.length;
                          i++)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(bottom: 20.0),
                          child: RequiredOptionRadio(
                            name: widget.menuItemRequiredOptions[i].name,
                            price: widget.menuItemRequiredOptions[i].price,
                            isSelected: selectedRequiredOptionRadio == i,
                            onChanged: (value) {
                              setState(() {
                                selectedRequiredOptionRadio = value ? i : null;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.menuItemRequiredOptions.isNotEmpty,
                child: const Divider(
                  thickness: 10,
                  color: Color(0xFFF6F6F6),
                ),
              ),
              Visibility(
                visible: widget.menuItemAddons.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 25, end: 25, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 15.0),
                        child: Text("Add-ons",
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      for (int i = 0; i < widget.menuItemAddons.length; i++)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 20),
                          child: AddonCheckBox(
                            value: addonCheckStates[i],
                            onChanged: (value) => toggleAddonCheckbox(i),
                            name: widget.menuItemAddons[i].name,
                            price: widget.menuItemAddons[i].price,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: decrementQuantity,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$quantity',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: incrementQuantity,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
              child: MainButton(
                  onTap: () {
                    // Check if quantity is greater than 0
                    if (quantity <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Quantity must be greater than 0.'),
                        ),
                      );
                      return; // Exit the function without adding to cart
                    }

                    // Check if required option is selected
                    if (widget.menuItemRequiredOptions.isNotEmpty &&
                        selectedRequiredOptionRadio == null) {
                      // Show a dialog or snackbar indicating that a required option must be selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a required option.'),
                        ),
                      );
                      return; // Exit the function without adding to cart
                    }
                    final newBasketItem = BasketItem(
                      id: widget.menuItemId,
                      food: Food(
                        id: widget.menuItemId,
                        restaurantId: widget.menuItemRestaurantId,
                        name: widget.menuItemName,
                        description: widget.menuItemDescription,
                        imagePath: widget.menuItemImagePath,
                        price: widget.menuItemPrice,
                        foodCategory: widget.menuItemFoodCategory,
                        availableAddons: selectedAddons,
                        requiredOptions: selectedRequiredOptionRadio != null
                            ? [
                                widget.menuItemRequiredOptions[
                                    selectedRequiredOptionRadio!]
                              ]
                            : [],
                      ),
                      quantity: quantity,
                      selectedAddons: selectedAddons,
                      selectedRequiredOption:
                          selectedRequiredOptionRadio != null
                              ? widget.menuItemRequiredOptions[
                                  selectedRequiredOptionRadio!]
                              : RequiredOption(name: 'none', price: 0),
                    );

                    // Add or update the item in the basket
                    final updatedItem =
                        BasketManager.addToBasket(newBasketItem);

                    print(BasketManager.basketItems);

                    // If the item was added to the basket as a new item,
                    // close the current page and navigate back to the MenuPage
                    Navigator.of(context).pop();
                  },
                  text: "Add to basket"),
            ),
          ),
        ],
      ),
    );
  }
}
