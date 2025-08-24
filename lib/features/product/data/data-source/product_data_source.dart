import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/features/product/data/data-source/firebase_product_data_source.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_data_source.g.dart';

@Riverpod(keepAlive: true)
ProductDataSource productDataSource(Ref ref) {
  return FirebaseProductDataSource();
}
abstract class ProductDataSource {
  Future<void> addProduct(Product product);
  Future<List<Product>> getProducts();
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
  Future<Map<String, dynamic>> dailyStats();
  // sale product
  Future<void> sellProduct({
    required String productId,
    required int quantitySold,
    required double sellingPrice,});

  // get sold products
  Future<List<Product>> getSoldProducts();

  // get monthly stats with month
  Future<Map<String, dynamic>> monthlyStats(int month);

  // most sold product in that month
  Future<List<Product>> mostSoldProducts(int month);
}