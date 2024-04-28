import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Map<String, int> items = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/cart.png'),
                  const Text(
                    'Add items to start a basket',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 300,
                    child: Text(
                      'Once you add items from a restuarant or store, your basket will appear here.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemName = items.keys.toList()[index];
                final itemCount = items.values.toList()[index];
                return ListTile(
                  title: Text('$itemName (Qty: $itemCount)'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _removeItem(itemName);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _addItem(itemName);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _addItem('Item ${items.length + 1}');
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem(String itemName) {
    setState(() {
      if (items.containsKey(itemName)) {
        items[itemName] = items[itemName]! + 1;
      } else {
        items[itemName] = 1;
      }
    });
  }

  void _removeItem(String itemName) {
    setState(() {
      if (items.containsKey(itemName)) {
        if (items[itemName]! > 1) {
          items[itemName] = items[itemName]! - 1;
        } else {
          items.remove(itemName);
        }
      }
    });
  }
}
