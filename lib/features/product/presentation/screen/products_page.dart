import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hiracosmetics/core/configs/router-configs/route_names.dart';
import 'package:hiracosmetics/core/dialogs/delete_dialog.dart';
import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/sell_product.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/product_card.dart';
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

    onSellProduct(product) => _sellProduct(context, product);

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
            child:
                filteredProducts.isEmpty
                    ? const Center(
                      child: Text(
                        "No products available",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(4),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          icon: product.type.icon,
                          category: product.type.label,
                          label: product.name,
                          count: product.quantity - product.soldQuantity,
                          borderColor: const Color(0xFF1A237E),
                          price: product.buyPrice,
                          onClick: () {
                            onSellProduct(product);
                          },
                          onTap: () {
                            context.pushNamed(
                              RouteNames.editProduct,
                              pathParameters: {'id': product.id},
                            );
                          },
                          onDelete: () async{
                            final confirmed = await showDeleteDialog(context);
                            if (confirmed) {
                              await ref
                                  .read(productNotifierProvider.notifier)
                                  .deleteProduct(product.id);
                            }
                          },
                        
                        );
                      },
                    ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}

void _sellProduct(BuildContext context, Product product) {
  showDialog(
    context: context,
    builder: (context) {
      return SellProductDialog(product: product);
    },
  );
}


