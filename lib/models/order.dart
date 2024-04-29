import 'package:final_year_project/models/food.dart';

class BasketItem {
  Food food;
  int quantity;
  List<Addon>? selectedAddons;
  RequiredOption? selectedRequiredOption;

  BasketItem({
    required this.food,
    required this.quantity,
    this.selectedAddons,
    this.selectedRequiredOption,
  });

  @override
  String toString() {
    return 'BasketItem: {food: ${food.toString()}, quantity: $quantity, chosenAddons: $selectedAddons, chosenOpts: $selectedRequiredOption}\n';
  }
}

class Basket {
  List<BasketItem> basketItems;

  Basket({required this.basketItems});

  factory Basket.fromItems(List<BasketItem> items) {
    return Basket(basketItems: items);
  }
}

class Orders {
  final String userId;
  final String restaurantId;
  final Basket basket;
  final double totalPrice;
  final DateTime orderTime;
  final OrderStatus orderStatus;

  Orders({
    required this.userId,
    required this.restaurantId,
    required this.basket,
    required this.totalPrice,
    required this.orderTime,
    required this.orderStatus,
  });
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  delivered,
  cancelled,
}
