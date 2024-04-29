import 'package:final_year_project/models/order.dart';
import 'package:final_year_project/services/database/basket_manager.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/widgets/history_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: basketItems.isEmpty
          ? SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 25, vertical: 25),
                    child: HistoryButton(onTap: () {}, text: "History"),
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
                return ListTile(
                  title: Text(item.food.name),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _decreaseQuantity(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _increaseQuantity(item),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
