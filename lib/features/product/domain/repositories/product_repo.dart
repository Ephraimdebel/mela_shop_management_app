import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/data-source/product_data_source.dart';
import '../../data/models/product.dart';
import '../../data/repo/product_repo_impl.dart';

part 'product_repo.g.dart';

@riverpod
ProductRepo productRepository(Ref ref) {
  return ProductRepoImpl(
      productDataSource: ref.read(productDataSourceProvider));
}

abstract class ProductRepo {
  Future<Either<String, Unit>> addProduct(Product product);
  Future<Either<String, List<Product>>> getProducts();
  Future<Either<String, Unit>> updateProduct(Product product);
  Future<Either<String, Unit>> deleteProduct(String id);
  Future<Either<String, Map<String, dynamic>>> dailyStats();
  // sale product
  Future<Either<String, Unit>> sellProduct({
    required String productId,
    required int quantitySold,
    required double sellingPrice,
  });

  // get sold products
  Future<Either<String, List<Product>>> getSoldProducts();

  // get monthly stats
  Future<Either<String, Map<String, dynamic>>> monthlyStats(int month);

  // most sold product in that month
  Future<Either<String, List<Product>>> mostSoldProducts(int month);
}
