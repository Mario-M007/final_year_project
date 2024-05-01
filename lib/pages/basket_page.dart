import 'package:flutter/material.dart';
import 'package:final_year_project/models/order.dart';
import 'package:final_year_project/services/database/basket_manager.dart';
import 'package:final_year_project/services/database/order_service.dart';
import 'package:final_year_project/widgets/history_button.dart';
import 'package:final_year_project/widgets/main_button.dart';
import 'package:final_year_project/pages/order_history_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({Key? key}) : super(key: key);

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  List<BasketItem> basketItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize basketItems with items from BasketManager
    basketItems = BasketManager.basketItems;
  }

  void _updateBasketItems() {
    setState(() {
      // Update basketItems with items from BasketManager
      basketItems = BasketManager.basketItems;
    });
  }

  void _increaseQuantity(BasketItem item) {
    setState(() {
      BasketManager.increaseQuantity(item);
      _updateBasketItems();
    });
  }

  void _decreaseQuantity(BasketItem item) {
    setState(() {
      BasketManager.decreaseQuantity(item);
      _updateBasketItems();

      // If the quantity becomes 0, remove the item from the basket
      if (item.quantity == 0) {
        BasketManager.removeFromBasket(item);
        _updateBasketItems();
      }
    });
  }

  Future<void> _confirmOrder() async {
    try {
      // Get the current user ID from Firebase Authentication
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Get the restaurant ID from the first item in the basket
      String restaurantId = '';
      if (basketItems.isNotEmpty) {
        restaurantId = basketItems.first.food.restaurantId;
      }

      // Create a Basket object from the list of basket items
      Basket basket = Basket.fromItems(basketItems);

      // Create an Order object from the basket items
      final order = Orders(
        isForDelivery: BasketManager.isForDelivery,
        userId: userId,
        restaurantId: restaurantId,
        totalPrice: _calculateTotalPrice(),
        orderTime: DateTime.now(),
        orderStatus: OrderStatus.confirmed,
        basket: basket, // Pass the Basket object
      );

      // Save the order to Firestore
      final orderService = OrderService();
      await orderService.saveOrder(order);

      // Clear the basket after saving the order
      BasketManager.clearBasket();
      _updateBasketItems();

      // Show a message or navigate to a confirmation screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order confirmed')),
      );
    } catch (e) {
      print('Error confirming order: $e');
      // Handle errors accordingly
    }
  }

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (final item in basketItems) {
      totalPrice += _calculateTotalPriceForItem(
          item); // Update total price calculation for each item
    }
    return totalPrice;
  }

  double _calculateTotalPriceForItem(BasketItem item) {
    double totalPrice = item.food.price * item.quantity;
    if (item.selectedAddons != null) {
      for (final addon in item.selectedAddons!) {
        totalPrice +=
            addon.price * item.quantity; // Update addon price calculation
      }
    }
    if (item.selectedRequiredOption != null) {
      totalPrice += item.selectedRequiredOption!.price *
          item.quantity; // Update selected option price calculation
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basket'),
      ),
      body: basketItems.isEmpty
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 25, vertical: 25),
                    child: HistoryButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryPage(),
                          ),
                        );
                      },
                      text: "History",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 70),
                    child: Center(child: Image.asset('lib/assets/cart.png')),
                  ),
                  const Center(
                    child: Text(
                      'Add items to start a basket',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Center(
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        'Once you add items from a restaurant or store, your basket will appear here.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: basketItems.length,
              itemBuilder: (context, index) {
                final item = basketItems[index];
                final totalPrice = _calculateTotalPriceForItem(item);
                final selectedAddons = item.selectedAddons ?? [];
                final selectedRequiredOption = item.selectedRequiredOption;
                return ListTile(
                  title: Text(item.food.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedRequiredOption != null)
                        Text(
                            'Selected Option: ${selectedRequiredOption.name} (+\$${(selectedRequiredOption.price * item.quantity).toStringAsFixed(2)})'),
                      if (selectedAddons.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selected Addons:'),
                            ...selectedAddons.map((addon) => Text(
                                '${addon.name} (+\$${(addon.price * item.quantity).toStringAsFixed(2)})')),
                          ],
                        ),
                      Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decreaseQuantity(item),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _increaseQuantity(item),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: basketItems.isEmpty
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
              child: SizedBox(
                height: 50,
                child: MainButton(
                  onTap: _confirmOrder,
                  text: 'Confirm',
                ),
              ),
            ),
    );
  }
}
