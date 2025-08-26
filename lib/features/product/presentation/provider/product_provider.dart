import 'package:flutter/material.dart';
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
        print('Failed to load products: $error');
        state = []; // empty list instead of crashing

        // throw Exception('Failed to load products: $error');
      },
      (products) {
        // Successfully loaded products
        state = products;
      },
    );
  }


// in ProductNotifier
Stream<List<Product>> getSoldProducts() {
  return ref.read(productRepositoryProvider).getSoldProducts().map(
    (either) => either.fold(
      (error) {
        throw Exception('Failed to load sold products: $error');
      },
      (products) => products,
    ),
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
      createdAt: null,
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
        state = [product,...state, ];
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
      // Instead of throwing, you can show a SnackBar or log the error
      debugPrint('Failed to sell product: $error');
      // Optionally notify UI:
      // state = state; // trigger rebuild if needed
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
  Stream<Map<String, dynamic>> getDailyStats(){
    return ref.read(productRepositoryProvider).dailyStats().map(
      (either) => either.fold(
        (error) {
          throw Exception('Failed to load daily stats: $error');
        },
        (stats) => stats,
      ),
    );
    // yield* result.fold(
    //   (error) async* {
    //     // Handle error
    //     throw Exception('Failed to load daily stats: $error');
    //   },
    //   (stats) async* {
    //     // Successfully loaded daily stats
    //     yield stats;
    //   },
    // );
  }
  // // monthly stats will accept which month
  //       // Handle error
  //       throw Exception('Failed to load daily stats: $error');
  //     },
  //     (stats) {
  //       // Successfully loaded daily stats
  //       return stats;
  //     },
  //   );
  // }
  // monthly stats will accept which month
  Stream<Map<String, dynamic>> getMonthlyStats(int month) {
    return ref.read(productRepositoryProvider).monthlyStats(month).map(
      (either) => either.fold(
        (error) {
          // Handle error
          throw Exception('Failed to load monthly stats: $error');
        },
        (stats) {
          // Successfully loaded monthly stats
          return stats;
        },
      ),
    );
  }

  // monthly stats will accept which month and give most sold products
  Stream<List<Product>> getMostSoldProducts(int month) {
    return ref.read(productRepositoryProvider).mostSoldProducts(month).map(
      (either) => either.fold(
        (error) {
          // Handle error
          throw Exception('Failed to load most sold products: $error');
        },
        (products) {
          // Successfully loaded most sold products
          return products;
        },
      ),
    );
  }

  // category performance
  Stream<Map<String, dynamic>> getCategoryPerformance(int month) {
    return ref.read(productRepositoryProvider).categoryPerformance(month).map(
      (either) => either.fold(
        (error) {
          // Handle error
          throw Exception('Failed to load category performance: $error');
        },
        (performance) {
          // Successfully loaded category performance
          return performance;
        },
      ),
    );
  }

  // get product by Id Future
  Future<Product?> getProductById(String id) async {
    final either = await ref.read(productRepositoryProvider).getProductById(id);
    return either.fold(
      (error) {
        // Handle error
        throw Exception('Failed to load product: $error');
      },
      (product) {
        // Successfully loaded product
        return product;
      },
    );
  }

  // update product
  Future<void> updateProduct(Product product) async {
    final result = await ref.read(productRepositoryProvider).updateProduct(product);
    result.fold(
      (error) {
        // Instead of throwing, you can show a SnackBar or log the error
        debugPrint('Failed to update product: $error');
        // Optionally notify UI:
        // state = state; // trigger rebuild if needed
      },
      (_) {
        // Successfully updated product
        state = state.map((p) {
          if (p.id == product.id) {
            return product;
          }
          return p;
        }).toList();
      },
    );
  }

  // delete product
  Future<void> deleteProduct(String id) async {
    final result = await ref.read(productRepositoryProvider).deleteProduct(id);
    result.fold(
      (error) {
        // Instead of throwing, you can show a SnackBar or log the error
        debugPrint('Failed to delete product: $error');
        // Optionally notify UI:
        // state = state; // trigger rebuild if needed
      },
      (_) {
        // Successfully deleted product
        state = state.where((p) => p.id != id).toList();
      },
    );
  }

}
