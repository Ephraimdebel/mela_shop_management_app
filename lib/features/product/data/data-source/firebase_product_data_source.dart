import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/data-source/product_data_source.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';

class FirebaseProductDataSource implements ProductDataSource {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('users').doc(_userId).collection('products');

  CollectionReference<Map<String, dynamic>> get _soldProductsCollection =>
      _firestore.collection('users').doc(_userId).collection('sold_products');

  @override
  Future<void> addProduct(Product product) async {
    if (_userId == null) throw Exception('User not authenticated');

    final productData = {
      ...product.toJson(),
      'userId': _userId,
      'createdAt': FieldValue.serverTimestamp(), // ✅ server time
    };

    await _productsCollection.doc(product.id).set(productData);
  }

  @override
  Future<List<Product>> getProducts() async {
    if (_userId == null) throw Exception('User not authenticated');

    final snapshot =
        await _productsCollection
            .where('userId', isEqualTo: _userId)
            .orderBy('createdAt', descending: true) // ✅ newest first
            .get();

    return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
  }

  // @override
  // Future<void> updateProduct(Product product) {
  //   // TODO: implement updateProduct
  //   throw UnimplementedError();
  // }

  @override
  Stream<Map<String, dynamic>> dailyStats() async* {
    if (_userId == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Firestore query for today's sales of the current user
    final snapshotStream =
        _soldProductsCollection
            .where('userId', isEqualTo: _userId)
            .where(
              'saledAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
            )
            .where('saledAt', isLessThan: Timestamp.fromDate(endOfDay))
            .snapshots();

    await for (var snapshot in snapshotStream) {
      double revenue = 0;
      double profit = 0;
      int totalUnitsSoldToday = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final soldQuantity = (data['soldQuantity'] ?? 0) as int;
        final price = (data['price'] ?? 0).toDouble();
        final buyPrice = (data['buyPrice'] ?? 0).toDouble();

        revenue += price * soldQuantity;
        profit += (price - buyPrice) * soldQuantity;
        totalUnitsSoldToday += soldQuantity;
      }

      yield {
        'revenue': revenue,
        'profit': profit,
        'salesCount': snapshot.docs.length,
        'totalProductsSold': totalUnitsSoldToday,
      };
    }
  }

  @override
  Future<void> sellProduct({
    required String productId,
    required int quantitySold,
    required double sellingPrice,
  }) async {
    if (_userId == null) throw Exception('User not authenticated');

    final docRef = _productsCollection.doc(productId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) throw Exception('Product not found');

    final product = Product.fromJson(snapshot.data()!);

    // Check stock
    if (product.quantity - product.soldQuantity < quantitySold) {
      throw Exception('Not enough stock');
    }

    // Update original product's sold quantity
    final updatedSoldQuantity = product.soldQuantity + quantitySold;

    await docRef.update({
      'soldQuantity': updatedSoldQuantity,
      'price': sellingPrice,
      'isSaled': updatedSoldQuantity >= product.quantity,
      'saledAt': FieldValue.serverTimestamp(), // 🔥 use server timestamp
    });

    // Store sold product in sold_products collection
    await _soldProductsCollection.add({
      'productId': product.id,
      'name': product.name,
      'price': sellingPrice,
      'buyPrice': product.buyPrice,
      'quantity': quantitySold,
      'soldQuantity': quantitySold,
      'isSaled': true,
      'type': product.type.name,
      'createdAt':
          product.createdAt != null
              ? Timestamp.fromDate(product.createdAt!)
              : FieldValue.serverTimestamp(), // optional
      'saledAt': FieldValue.serverTimestamp(), // 🔥 newest sale
      'userId': _userId,
    });
  }

  @override
  Future<void> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  //   @override
  // Future<List<Product>> getSoldProducts() async {
  //   if (_userId == null) throw Exception('User not authenticated');

  //   final snapshot = await _soldProductsCollection.get();

  //   return snapshot.docs
  //       .map((doc) => Product.fromJson(doc.data()))
  //       .toList();
  // }

  @override
  Stream<List<Product>> getSoldProducts() {
    if (_userId == null) {
      throw Exception('User not authenticated');
    }

    return _soldProductsCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('saledAt', descending: true) // 🔥 newest sold products first
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return Product(
                  id: data['productId'],
                  name: data['name'],
                  price: (data['price'] as num).toDouble(),
                  buyPrice: (data['buyPrice'] as num).toDouble(),
                  quantity: data['quantity'],
                  soldQuantity: data['soldQuantity'],
                  isSaled: data['isSaled'] ?? true,
                  type: Category.values.firstWhere(
                    (e) => e.name == data['type'],
                  ),
                  createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
                  saledAt: (data['saledAt'] as Timestamp?)?.toDate(),
                );
              }).toList(),
        );
  }

  // get monthly stats with month
 @override
Stream<Map<String, dynamic>> monthlyStats(int month) {
  if (_userId == null) throw Exception('User not authenticated');

  final startOfMonth = DateTime(DateTime.now().year, month, 1);
  final endOfMonth = DateTime(DateTime.now().year, month + 1, 1);

  return _soldProductsCollection
      .where(
        'saledAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
      )
      .where('saledAt', isLessThan: Timestamp.fromDate(endOfMonth))
      .snapshots()
      .map((snapshot) {
    double revenue = 0;
    double profit = 0;
    int totalUnitsSold = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final soldQuantity = data['soldQuantity'] as int;
      final price = (data['price'] as num).toDouble();
      final buyPrice = (data['buyPrice'] as num).toDouble();

      revenue += price * soldQuantity;
      profit += (price - buyPrice) * soldQuantity;
      totalUnitsSold += soldQuantity;
    }

    return {
      'revenue': revenue,
      'profit': profit,
      'salesCount': snapshot.docs.length,
      'totalProductsSold': totalUnitsSold,
    };
  });
}

@override
Stream<List<Product>> mostSoldProducts(int month) {
  if (_userId == null) throw Exception('User not authenticated');

  final startOfMonth = DateTime(DateTime.now().year, month, 1);
  final endOfMonth = DateTime(DateTime.now().year, month + 1, 1);

  return _soldProductsCollection
      .where(
        'saledAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
      )
      .where('saledAt', isLessThan: Timestamp.fromDate(endOfMonth))
      .snapshots()
      .map((snapshot) {
    // Aggregate products by productId
    final Map<String, Product> aggregated = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final productId = data['productId'];
      final soldQuantity = data['soldQuantity'] as int;

      if (aggregated.containsKey(productId)) {
        final existing = aggregated[productId]!;
        aggregated[productId] = existing.copyWith(
          soldQuantity: existing.soldQuantity + soldQuantity,
        );
      } else {
        aggregated[productId] = Product(
          id: productId,
          name: data['name'],
          price: (data['price'] as num).toDouble(),
          buyPrice: (data['buyPrice'] as num).toDouble(),
          quantity: data['quantity'],
          soldQuantity: soldQuantity,
          isSaled: data['isSaled'] ?? true,
          type: Category.values.firstWhere((e) => e.name == data['type']),
          createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
          saledAt: (data['saledAt'] as Timestamp?)?.toDate(),
        );
      }
    }

    final sorted = aggregated.values.toList()
      ..sort((a, b) => b.soldQuantity.compareTo(a.soldQuantity));

    return sorted.take(5).toList();
  });
}


  // from each category performance per month
  @override
Stream<Map<String, dynamic>> categoryPerformance(int month) {
  if (_userId == null) throw Exception('User not authenticated');

  final startOfMonth = DateTime(DateTime.now().year, month, 1);
  final endOfMonth = DateTime(DateTime.now().year, month + 1, 1);

  return _soldProductsCollection
      .where(
        'saledAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
      )
      .where('saledAt', isLessThan: Timestamp.fromDate(endOfMonth))
      .snapshots()
      .map((snapshot) {
    // Initialize performance map
    final Map<Category, Map<String, dynamic>> performance = {
      for (var category in Category.values)
        category: {
          'productsSold': 0,
          'revenue': 0.0,
          'profit': 0.0,
        }
    };

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final category = Category.values.firstWhere(
        (e) => e.name == data['type'],
      );
      final soldQuantity = data['soldQuantity'] as int;
      final price = (data['price'] as num).toDouble();
      final buyPrice = (data['buyPrice'] as num).toDouble();

      performance[category]!['productsSold'] += soldQuantity;
      performance[category]!['revenue'] += price * soldQuantity;
      performance[category]!['profit'] += (price - buyPrice) * soldQuantity;
    }

    // Convert keys to string for easier UI use
    return performance.map((key, value) => MapEntry(key.name, value));
  });
}

}
