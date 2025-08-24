import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hiracosmetics/features/product/presentation/screen/widgets/overview.dart';

class DailyStatsPage extends ConsumerWidget {
  const DailyStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyStats =
        ref.watch(productNotifierProvider.notifier).getDailyStats();
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Stats')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: dailyStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  Text(
                    "Overview",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 159, 158, 158),
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16),
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
          }
        },
      ),
    );
  }
}
