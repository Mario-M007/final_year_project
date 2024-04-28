import 'package:final_year_project/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:final_year_project/widgets/addon_check_box.dart';

class OrderSelectionPage extends StatefulWidget {
  const OrderSelectionPage({Key? key}) : super(key: key);

  @override
  State<OrderSelectionPage> createState() => _OrderSelectionPageState();
}

class _OrderSelectionPageState extends State<OrderSelectionPage> {
  int quantity = 0;

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
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 15),
                child: SizedBox(
                  width: 300,
                  height: 150,
                  child: Image(
                    image: NetworkImage(
                        'https://i.pinimg.com/originals/73/fd/cf/73fdcf738ad095f80c89ff41e52eb8ed.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text("Mushroom Pizza",
                    style: Theme.of(context).textTheme.headline6),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text("\$21.00",
                    style: Theme.of(context).textTheme.headline6),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: Text(
                  "Garlic, olive oil base, mozarella, cremini mushrooms, ricotta, thyme, white truffle oil. Add arugula for an extra charge",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Color.fromARGB(255, 139, 139, 139)),
                ),
              ),
              const Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 25, end: 25, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 15.0),
                      child: Text("Addons",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    AddonCheckBox(
                      value: false,
                      onChanged: (value) {},
                      name: "Extra cheese",
                      price: 2.0,
                    ),
                    AddonCheckBox(
                      value: false,
                      onChanged: (value) {},
                      name: "Extra cheese",
                      price: 2.0,
                    ),
                    AddonCheckBox(
                      value: false,
                      onChanged: (value) {},
                      name: "Extra cheese",
                      price: 2.0,
                    ),
                  ],
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
                    icon: Icon(Icons.remove),
                    onPressed: decrementQuantity,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$quantity',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
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
