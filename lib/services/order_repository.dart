import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/purchase_order.dart';

/// Purchase history lives at `users/{uid}/history`.
class OrderRepository {
  OrderRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _history(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.history);

  Future<void> placeOrder({
    required String uid,
    required List<CartItem> items,
  }) async {
    final total = items.fold<double>(0, (sum, item) => sum + item.subtotal);
    await _history(uid).add({
      'timestamp': Timestamp.now(),
      'totalPrice': total,
      'items': [
        for (final item in items)
          {
            'itemCode': item.product.code,
            'itemName': item.product.name,
            'quantity': item.quantity,
            'price': item.product.price,
          },
      ],
    });
  }

  Stream<List<PurchaseOrder>> watchOrders(String uid) => _history(uid)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((s) => s.docs.map(PurchaseOrder.fromFirestore).toList());
}
