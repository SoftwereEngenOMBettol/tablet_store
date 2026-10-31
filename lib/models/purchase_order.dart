import 'package:cloud_firestore/cloud_firestore.dart';

class OrderLine {
  const OrderLine({
    required this.code,
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String code;
  final String name;
  final int quantity;
  final double price;

  double get subtotal => price * quantity;

  factory OrderLine.fromMap(Map<String, dynamic> map) => OrderLine(
        code: map['itemCode'] as String? ?? '',
        name: map['itemName'] as String? ?? '',
        quantity: (map['quantity'] as num?)?.toInt() ?? 0,
        price: (map['price'] as num?)?.toDouble() ?? 0,
      );
}

/// A saved purchase: `users/{uid}/history/{orderId}`.
class PurchaseOrder {
  const PurchaseOrder({
    required this.id,
    required this.placedAt,
    required this.total,
    required this.lines,
  });

  final String id;
  final DateTime placedAt;
  final double total;
  final List<OrderLine> lines;

  factory PurchaseOrder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawLines = data['items'] as List<dynamic>? ?? <dynamic>[];
    final timestamp = data['timestamp'];
    return PurchaseOrder(
      id: doc.id,
      placedAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
      total: (data['totalPrice'] as num?)?.toDouble() ?? 0,
      lines: rawLines
          .map((e) => OrderLine.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
