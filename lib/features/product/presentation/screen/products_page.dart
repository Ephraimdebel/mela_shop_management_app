import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiracosmetics/core/configs/router-configs/route_names.dart';
import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/sell_product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final unfilteredProducts = ref.watch(productNotifierProvider);

    // if no category selected (All), show everything
    final filteredProducts =
        selectedCategory == null
            ? unfilteredProducts
            : unfilteredProducts
                .where((p) => p.type == selectedCategory)
                .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to Add Product page
              context.pushNamed(RouteNames.addProduct);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter with "All" tab
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Category.values.length + 1, // +1 for "All"
              itemBuilder: (context, index) {
                if (index == 0) {
                  // All tab
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
                        color:
                            selected ? Colors.white : const Color(0xFF1A237E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "All",
                        style: TextStyle(
                          color:
                              selected
                                  ? const Color(0xFF1A237E)
                                  : Colors.white70,
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
                      ref.read(selectedCategoryProvider.notifier).state =
                          category;
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            selected ? Colors.white : const Color(0xFF1A237E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category.label,
                        style: TextStyle(
                          color:
                              selected
                                  ? const Color(0xFF1A237E)
                                  : Colors.white70,
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
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // one per row like your screenshot
                mainAxisSpacing: 16,
                childAspectRatio: 2, // adjust to look like card
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: type + stock badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.type.label,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D1344),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${product.quantity - product.soldQuantity} in stock',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Name + price (left aligned)
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.buyPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 205, 205, 205),
                          ),
                        ),

                        const Spacer(), // pushes button to bottom
                        // Full width button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _sellProduct(context, product),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: const Color(0xFF0D1344),
                            ),
                            child: const Text('Sell Product'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _sellProduct(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (context) {
      return SellProductDialog( product: product,
      );
    },
  );
}
