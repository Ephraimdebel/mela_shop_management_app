import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/overview.dart';

final dailyStatsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(productNotifierProvider.notifier).getDailyStats();
});

class DailyStatsPage extends ConsumerWidget {
  const DailyStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyStats = ref.watch(dailyStatsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Stats')),
      body: dailyStats.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    "Overview",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                OverviewCard(
                  icon: Icons.attach_money,
                  label: 'Total Revenue',
                  count: data['revenue'],
                  borderColor: Colors.green,
                ),
                OverviewCard(
                  icon: Icons.attach_money,
                  label: 'Total Profit',
                  count: data['profit'],
                  borderColor: Colors.green,
                ),
                OverviewCard(
                  icon: Icons.shopping_cart,
                  label: 'Total Sales',
                  count: data['salesCount'],
                  borderColor: Colors.blue,
                ),
                OverviewCard(
                  icon: Icons.production_quantity_limits,
                  label: 'Total Products Sold',
                  count: data['totalProductsSold'],
                  borderColor: Colors.orange,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
