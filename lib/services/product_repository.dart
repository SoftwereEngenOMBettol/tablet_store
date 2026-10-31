import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/product.dart';

/// All Firestore access for the product catalog.
class ProductRepository {
  ProductRepository({FirebaseFirestore? firestore})
      : _products = (firestore ?? FirebaseFirestore.instance)
            .collection(FirestorePaths.products);

  final CollectionReference<Map<String, dynamic>> _products;

  Stream<List<Product>> watchProducts() => _products
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Product.fromFirestore).toList());

  Future<void> addProduct(Product product) => _products.add(product.toMap());

  Future<void> updateProduct(Product product) =>
      _products.doc(product.id).update(product.toMap());

  Future<void> deleteProduct(String id) => _products.doc(id).delete();
}
