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
    final productData = {...product.toJson(), 'userId': _userId};

    await _productsCollection.doc(product.id).set(productData);
  }

  // @override
  // Future<void> deleteProduct(String id) {
  //   // TODO: implement deleteProduct
  //   throw UnimplementedError();
  // }

  @override
  Future<List<Product>> getProducts() async {
    if (_userId == null) throw Exception('User not authenticated');
    final snapshot =
        await _productsCollection.where('userId', isEqualTo: _userId).get();
    return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
  }

  // @override
  // Future<void> updateProduct(Product product) {
  //   // TODO: implement updateProduct
  //   throw UnimplementedError();
  // }

  @override
Future<Map<String, dynamic>> dailyStats() async {
  if (_userId == null) throw Exception('User not authenticated');

  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  // ⚡ Note: You may need a Firestore composite index for userId + saledAt
  final snapshot = await _soldProductsCollection
      .where('userId', isEqualTo: _userId)
      .where('saledAt', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
      .where('saledAt', isLessThan: endOfDay.toIso8601String())
      .get();

  double revenue = 0;
  double profit = 0;
  int totalUnitsSoldToday = 0;

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final soldQuantity = data['soldQuantity'] as int;
    final price = (data['price'] as num).toDouble();
    final buyPrice = (data['buyPrice'] as num).toDouble();

    revenue += price * soldQuantity;
    profit += (price - buyPrice) * soldQuantity;
    totalUnitsSoldToday += soldQuantity;
  }

  return {
    'revenue': revenue,
    'profit': profit,
    'salesCount': snapshot.docs.length,
    'totalProductsSold': totalUnitsSoldToday,
  };
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
    'saledAt': DateTime.now().toIso8601String(),
  });

  // Store sold product in sold_products collection
  await _soldProductsCollection.add({
    'productId': product.id,
    'name': product.name,
    'price': sellingPrice,
    'buyPrice': product.buyPrice,
    'quantity': quantitySold,           // only this sale quantity
    'soldQuantity': quantitySold,
    'isSaled': true,
    'type': product.type.name,          // store enum as string
    'createdAt': product.createdAt.toIso8601String(),
    'saledAt': DateTime.now().toIso8601String(),
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
Future<List<Product>> getSoldProducts() async {
  if (_userId == null) throw Exception('User not authenticated');

  final snapshot = await _soldProductsCollection.get();

  return snapshot.docs.map((doc) {
    final data = doc.data();

    return Product(
      id: data['productId'],
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      buyPrice: (data['buyPrice'] as num).toDouble(),
      quantity: data['quantity'],
      soldQuantity: data['soldQuantity'],
      isSaled: data['isSaled'] ?? true,
      type: Category.values.firstWhere((e) => e.name == data['type']),
      createdAt: DateTime.parse(data['createdAt']),
      saledAt: DateTime.parse(data['saledAt']),
    );
  }).toList();
}

// get monthly stats with month
@override
Future<Map<String, dynamic>> monthlyStats(int month) async {
  if (_userId == null) throw Exception('User not authenticated');

  final startOfMonth = DateTime(DateTime.now().year, month, 1);
  final endOfMonth = DateTime(DateTime.now().year, month + 1, 1);

  final snapshot = await _soldProductsCollection
      .where('saledAt', isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
      .where('saledAt', isLessThan: endOfMonth.toIso8601String())
      .get();

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
}

// most sold product in that month
@override
Future<List<Product>> mostSoldProducts(int month) async {
  if (_userId == null) throw Exception('User not authenticated');

  final startOfMonth = DateTime(DateTime.now().year, month, 1);
  final endOfMonth = DateTime(DateTime.now().year, month + 1, 1);

  final snapshot = await _soldProductsCollection
      .where('saledAt', isGreaterThanOrEqualTo: startOfMonth.toIso8601String())
      .where('saledAt', isLessThan: endOfMonth.toIso8601String())
      .orderBy('soldQuantity', descending: true)
      .limit(5)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();

    return Product(
      id: data['productId'],
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      buyPrice: (data['buyPrice'] as num).toDouble(),
      quantity: data['quantity'],
      soldQuantity: data['soldQuantity'],
      isSaled: data['isSaled'] ?? true,
      type: Category.values.firstWhere((e) => e.name == data['type']),
      createdAt: DateTime.parse(data['createdAt']),
      saledAt: DateTime.parse(data['saledAt']),
    );
  }).toList();
}

}
