import 'package:final_year_project/models/food.dart';
import 'package:final_year_project/models/order.dart';

class BasketManager {
  static List<BasketItem> _basketItems = [];

  static List<BasketItem> get basketItems => _basketItems;

  static BasketItem addToBasket(BasketItem newItem) {
    // Check if an identical item already exists in the basket
    final existingItemIndex = _basketItems.indexWhere((element) =>
        element.food.id == newItem.food.id &&
        _compareAddonLists(element.selectedAddons, newItem.selectedAddons) &&
        _compareRequiredOption(
            element.selectedRequiredOption, newItem.selectedRequiredOption));

    if (existingItemIndex != -1) {
      // If an identical item exists, increase its quantity
      _basketItems[existingItemIndex].quantity += newItem.quantity;
      return _basketItems[existingItemIndex];
    } else {
      // If no identical item exists, add it to the basket
      _basketItems.add(newItem);
      return newItem;
    }
  }

  static bool _compareAddonLists(List<Addon>? list1, List<Addon>? list2) {
    // Compare two lists of addons
    if (list1?.length != list2?.length) return false;

    for (int i = 0; i < list1!.length; i++) {
      if (list1[i].name != list2?[i].name ||
          list1[i].price != list2?[i].price) {
        return false;
      }
    }
    return true;
  }

  static bool _compareRequiredOption(
      RequiredOption? option1, RequiredOption? option2) {
    // Compare two required options
    if (option1 == null && option2 == null) return true;
    if (option1 == null || option2 == null) return false;
    return option1.name == option2.name && option1.price == option2.price;
  }

  static void removeFromBasket(BasketItem item) {
    _basketItems.remove(item);
  }

  static void increaseQuantity(BasketItem item) {
    item.quantity++;
  }

  static void decreaseQuantity(BasketItem item) {
    if (item.quantity > 0) {
      item.quantity--;
    }
  }

  static void clearBasket() {
    _basketItems.clear();
  }
}
