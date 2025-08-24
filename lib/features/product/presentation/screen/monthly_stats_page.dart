import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/core/constants/constants.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/overview.dart';

/// Holds the selected month as an integer (1–12)
final selectedMonthProvider = StateProvider<int>((ref) => DateTime.now().month);

class MonthlyStatsPage extends ConsumerWidget {
  const MonthlyStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(selectedMonthProvider);

    // fetch monthly stats based on selected month
    final monthlyStatsFuture = ref
        .watch(productNotifierProvider.notifier)
        .getMonthlyStats(selectedMonth);
    final mostSoldProductsFuture = ref
        .watch(productNotifierProvider.notifier)
        .getMostSoldProducts(selectedMonth);
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Stats')),
      body: Column(
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
                  value: index + 1, // month number (1-12)
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

          // 🔄 Stats section
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: monthlyStatsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            OverviewCard(
                              icon: Icons.star,
                              label: "Top Revenue",
                              count: data['revenue'],
                              borderColor: Colors.blue,
                            ),
                            const SizedBox(height: 6),
                            OverviewCard(
                              icon: Icons.trending_up,
                              label: "Top Profit",
                              count: data['profit'],
                              borderColor: Colors.green,
                            ),
                            const SizedBox(height: 6),
                            OverviewCard(
                              icon: Icons.arrow_upward,
                              label: "Total Sales",
                              count: data['salesCount'],
                              borderColor: Colors.orange,
                            ),
                            const SizedBox(height: 6),
                            OverviewCard(
                              icon: Icons.shopping_cart,
                              label: "Total Products Sold",
                              count: data['totalProductsSold'],
                              borderColor: Colors.purple,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Most Sold Products",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            FutureBuilder<List<Product>>(
                              future: mostSoldProductsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else if (snapshot.hasData) {
                                  final products = snapshot.data!;
                                  return Column(
                                    children:
                                        products.map((product) {
                                          return ListTile(
                                            title: Text(product.name),
                                            subtitle: Text(
                                              'Sold: ${product.soldQuantity}',
                                            ),
                                          );
                                        }).toList(),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
