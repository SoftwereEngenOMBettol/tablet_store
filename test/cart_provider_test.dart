import 'package:flutter_test/flutter_test.dart';
import 'package:tablet_store/models/product.dart';
import 'package:tablet_store/providers/cart_provider.dart';

void main() {
  const tabletA = Product(
    id: 'a',
    code: '1001',
    name: 'Tablet A',
    price: 100,
    brand: 'Brand',
    imageUrl: '',
  );
  const tabletB = Product(
    id: 'b',
    code: '1002',
    name: 'Tablet B',
    price: 50.5,
    brand: 'Brand',
    imageUrl: '',
  );

  late CartProvider cart;

  setUp(() => cart = CartProvider());

  test('adding the same product increases its quantity', () {
    cart
      ..add(tabletA)
      ..add(tabletA);
    expect(cart.items, hasLength(1));
    expect(cart.totalQuantity, 2);
  });

  test('total sums every line', () {
    cart
      ..add(tabletA)
      ..add(tabletA)
      ..add(tabletB);
    expect(cart.total, 250.5);
  });

  test('decrease removes the item at zero', () {
    cart.add(tabletA);
    cart.decrease('a');
    expect(cart.isEmpty, isTrue);
  });

  test('clear empties the cart and notifies listeners', () {
    var notified = 0;
    cart
      ..addListener(() => notified++)
      ..add(tabletA)
      ..clear();
    expect(cart.isEmpty, isTrue);
    expect(notified, 2);
  });
}
