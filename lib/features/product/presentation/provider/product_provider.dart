import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/domain/repositories/product_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
part 'product_provider.g.dart';

@riverpod
class ProductNotifier extends _$ProductNotifier {
  @override
  List<Product> build() {
    _loadProducts();
    return [];
  }

  Future<void> _loadProducts() async {
    final result = await ref.read(productRepositoryProvider).getProducts();
    result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to load products: $error');
      },
      (products) {
        // Successfully loaded products
        state = products;
      },
    );
  }


// get sold products
  Future<List<Product>> getSoldProducts() async {
    final result = await ref.read(productRepositoryProvider).getSoldProducts();
    return result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to load sold products: $error');
      },
      (products) {
        // Successfully loaded sold products
        return products;
      },
    );
  }

  Future<void> addProduct(
    String name,
    double buyPrice,
    Category category,
    int quantity,
  ) async {
    final product = Product(
      id: const Uuid().v4(),
      name: name,
      price: buyPrice, // default selling price per unit
      buyPrice: buyPrice, // cost per unit
      quantity: quantity, // total stock
      soldQuantity: 0, // nothing sold yet
      isSaled: false, // initially not sold
      type: category,
      createdAt: DateTime.now(),
      saledAt: null, // no sale date yet
    );

    final result = await ref
        .read(productRepositoryProvider)
        .addProduct(product);
    result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to add product: $error');
      },
      (_) {
        // Successfully added product
        state = [...state, product];
      },
    );
  }

  // sell product
  Future<void> sellProduct({
    required String productId,
    required int quantitySold,
    required double sellingPrice,
  }) async {
    final result = await ref.read(productRepositoryProvider).sellProduct(
          productId: productId,
          quantitySold: quantitySold,
          sellingPrice: sellingPrice,
        );
    result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to sell product: $error');
      },
      (_) {
        // Successfully sold product
        state = state.map((product) {
          if (product.id == productId) {
            return product.copyWith(
              soldQuantity: product.soldQuantity + quantitySold,
              isSaled: product.soldQuantity + quantitySold >= product.quantity,
              price: sellingPrice,
              saledAt: DateTime.now(),
            );
          }
          return product;
        }).toList();
      },
    );
  }

  // get daily stats
  Future<Map<String, dynamic>> getDailyStats() async {
    final result = await ref.read(productRepositoryProvider).dailyStats();
    return result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to load daily stats: $error');
      },
      (stats) {
        // Successfully loaded daily stats
        return stats;
      },
    );
  }
  // monthly stats will accept which month
  Future<Map<String, dynamic>> getMonthlyStats(int month) async {
    final result = await ref.read(productRepositoryProvider).monthlyStats(month);
    return result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to load monthly stats: $error');
      },
      (stats) {
        // Successfully loaded monthly stats
        return stats;
      },
    );
  }

  // monthly stats will accept which month and give most sold products
  Future<List<Product>> getMostSoldProducts(int month) async {
    final result = await ref.read(productRepositoryProvider).mostSoldProducts(month);
    return result.fold(
      (error) {
        // Handle error
        throw Exception('Failed to load most sold products: $error');
      },
      (products) {
        // Successfully loaded most sold products
        return products;
      },
    );
  }

}
