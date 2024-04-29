import 'package:flutter/material.dart';
import 'package:final_year_project/models/food.dart';
import 'package:final_year_project/widgets/main_button.dart';
import 'package:final_year_project/widgets/required_option_radio.dart';
import 'package:final_year_project/widgets/addon_check_box.dart';

class OrderSelectionPage extends StatefulWidget {
  final String menuItemId;
  final String menuItemRestaurantId;
  final String menuItemName;
  final String menuItemDescription;
  final String menuItemImagePath;
  final double menuItemPrice;
  final FoodCategory menuItemFoodCategory;
  final List<Addon> menuItemAddons;
  final List<RequiredOptions> menuItemRequiredOptions;

  const OrderSelectionPage({
    super.key,
    required this.menuItemId,
    required this.menuItemRestaurantId,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.menuItemImagePath,
    required this.menuItemPrice,
    required this.menuItemFoodCategory,
    required this.menuItemAddons,
    required this.menuItemRequiredOptions,
  });

  @override
  State<OrderSelectionPage> createState() => _OrderSelectionPageState();
}

class _OrderSelectionPageState extends State<OrderSelectionPage> {
  int quantity = 0;

  List<bool> addonCheckStates = [];
  List<Addon> selectedAddons = [];

  int? selectedRequiredOption;

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
                child: Text("\$${widget.menuItemPrice}",
                    style: Theme.of(context).textTheme.titleLarge),
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
                            isSelected: selectedRequiredOption == i,
                            onChanged: (value) {
                              setState(() {
                                selectedRequiredOption = value ? i : null;
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
                        child: Text("Extras",
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
              child: GestureDetector(
                onTap: () {
                  // Add functionality to add item to cart
                },
                child: MainButton(onTap: () {}, text: "Add to cart"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
