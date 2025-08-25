import 'package:flutter/material.dart';
import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/product_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

double calculateSingleProductProfit(Product product) {
  return (product.price - product.buyPrice) * product.soldQuantity;
}

final soldProductsProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productNotifierProvider.notifier).getSoldProducts();
});

class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final asyncSoldProducts = ref.watch(soldProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: asyncSoldProducts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (soldProducts) {
          // Filter by category
          final filteredProducts = selectedCategory == null
              ? soldProducts
              : soldProducts
                  .where((p) => p.type == selectedCategory)
                  .toList();

          return Column(
            children: [
              // Category filter
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Category.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final selected = selectedCategory == null;
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state = null;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: selected ? Colors.white : const Color(0xFF1A237E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: selected ? const Color(0xFF1A237E) : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final category = Category.values[index - 1];
                      final selected = selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state = category;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: selected ? Colors.white : const Color(0xFF1A237E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category.label,
                            style: TextStyle(
                              color: selected ? const Color(0xFF1A237E) : Colors.white70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              // Products grid
              Expanded(
                child: 
                filteredProducts.isEmpty
                ? const Center(
                  child: Text(
                    "No sold products available",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ) : ListView.builder(
                  padding: const EdgeInsets.all(4),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      icon: product.type.icon,
                      category: product.type.label,
                      label: product.name,
                      count: product.soldQuantity,
                      borderColor: const Color(0xFF1A237E),
                      price: calculateSingleProductProfit(product),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
