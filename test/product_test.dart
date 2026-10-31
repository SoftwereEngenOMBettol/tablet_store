import 'package:flutter_test/flutter_test.dart';
import 'package:tablet_store/models/product.dart';

void main() {
  test('toMap keeps the original Firestore field names', () {
    const product = Product(
      code: '1001',
      name: 'Tablet A',
      price: 99.5,
      brand: 'Brand',
      imageUrl: 'https://example.com/a.png',
    );

    expect(product.toMap(), {
      'itemCode': '1001',
      'itemName': 'Tablet A',
      'itemPrice': 99.5,
      'brand': 'Brand',
      'Improduct': 'https://example.com/a.png',
    });
  });
}
