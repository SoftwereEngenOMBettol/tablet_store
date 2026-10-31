import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// In-memory shopping cart.
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = <String, CartItem>{};

  List<CartItem> get items => List<CartItem>.unmodifiable(_items.values);
  bool get isEmpty => _items.isEmpty;

  int get totalQuantity =>
      _items.values.fold<int>(0, (sum, item) => sum + item.quantity);

  double get total =>
      _items.values.fold<double>(0, (sum, item) => sum + item.subtotal);

  void add(Product product) {
    final key = product.id ?? product.code;
    _items.update(
      key,
      (item) => item.copyWith(quantity: item.quantity + 1),
      ifAbsent: () => CartItem(product: product),
    );
    notifyListeners();
  }

  void increase(String key) {
    final item = _items[key];
    if (item == null) return;
    _items[key] = item.copyWith(quantity: item.quantity + 1);
    notifyListeners();
  }

  /// Decreases the quantity and removes the item when it reaches zero.
  void decrease(String key) {
    final item = _items[key];
    if (item == null) return;
    if (item.quantity <= 1) {
      _items.remove(key);
    } else {
      _items[key] = item.copyWith(quantity: item.quantity - 1);
    }
    notifyListeners();
  }

  void remove(String key) {
    if (_items.remove(key) != null) notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
