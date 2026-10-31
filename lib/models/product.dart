import 'package:cloud_firestore/cloud_firestore.dart';

/// A tablet in the catalog.
///
/// Firestore field names (`itemCode`, `itemName`, `itemPrice`, `Improduct`)
/// are kept as they were so existing data keeps working.
class Product {
  const Product({
    this.id,
    required this.code,
    required this.name,
    required this.price,
    required this.brand,
    required this.imageUrl,
  });

  final String? id;
  final String code;
  final String name;
  final double price;
  final String brand;
  final String imageUrl;

  factory Product.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Product(
      id: doc.id,
      code: data['itemCode'] as String? ?? '',
      name: data['itemName'] as String? ?? '',
      price: (data['itemPrice'] as num?)?.toDouble() ?? 0,
      brand: data['brand'] as String? ?? '',
      imageUrl: data['Improduct'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'itemCode': code,
        'itemName': name,
        'itemPrice': price,
        'brand': brand,
        'Improduct': imageUrl,
      };

  @override
  bool operator ==(Object other) =>
      other is Product && other.id == id && other.code == code;

  @override
  int get hashCode => Object.hash(id, code);
}
