import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/core/constants/constants.dart';
import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/category_card.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/order_card.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/overview.dart';

/// Holds the selected month as an integer (1–12)
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);

class MonthlyStatsPage extends ConsumerWidget {
  const MonthlyStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);

    // 🔄 Use streams now
    final monthlyStatsStream = ref
        .watch(productNotifierProvider.notifier)
        .getMonthlyStats(selectedMonth);
    final mostSoldProductsStream = ref
        .watch(productNotifierProvider.notifier)
        .getMostSoldProducts(selectedMonth);
    final categoryPerformanceStream = ref
        .watch(productNotifierProvider.notifier)
        .getCategoryPerformance(selectedMonth);

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Stats')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          // 🔽 Month selector dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<int>(
              value: selectedMonth,
              isExpanded: true,
              items: List.generate(
                12,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text(months[index]),
                ),
              ),
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedMonthProvider.notifier).state = value;
                }
              },
            ),
          ),
          const SizedBox(height: 12),

          // 🔄 Stats section (STREAM)
          Expanded(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: monthlyStatsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overview
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Text(
                            "Overview",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        OverviewCard(
                          icon: Icons.star,
                          label: "Total Revenue",
                          count: data['revenue'],
                          borderColor: Colors.blue,
                        ),
                        OverviewCard(
                          icon: Icons.trending_up,
                          label: "Total Profit",
                          count: data['profit'],
                          borderColor: Colors.green,
                        ),
                        OverviewCard(
                          icon: Icons.arrow_upward,
                          label: "Total Sales",
                          count: data['salesCount'],
                          borderColor: Colors.orange,
                        ),
                        OverviewCard(
                          icon: Icons.shopping_cart,
                          label: "Total Products Sold",
                          count: data['totalProductsSold'],
                          borderColor: Colors.purple,
                        ),
                        const SizedBox(height: 16),

                        // Most Sold Products
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: const Text(
                            "Most Sold Products",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        StreamBuilder<List<Product>>(
                          stream: mostSoldProductsStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              final products = snapshot.data!;
                              if (products.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No sold products found for this month.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                );
                              }
                              return Column(
                                children:
                                    products.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final product = entry.value;
                                  return OrderCard(
                                    rank: index + 1,
                                    label: product.name,
                                    count: product.soldQuantity,
                                    borderColor: const Color(0xFF1A237E),
                                  );
                                }).toList(),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 16),

                        // Category Performance
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Category Performance",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        StreamBuilder<Map<String, dynamic>>(
                          stream: categoryPerformanceStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              final performance = snapshot.data!;
                              return Column(
                                children: performance.entries.map((entry) {
                                  final category = entry.key;
                                  final data = entry.value;
                                  return CategoryCard(
                                    label: category,
                                    icon: categoryIcons[category] ??
                                        Icons.category,
                                    productSold: data['productsSold'] ?? 0,
                                    revenue: data['revenue'] ?? 0,
                                    profit: data['profit'] ?? 0,
                                    borderColor: const Color.fromARGB(
                                        255, 28, 126, 26),
                                  );
                                }).toList(),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
