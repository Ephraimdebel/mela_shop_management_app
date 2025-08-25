import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final int productSold;
  final String label;
  final num revenue;
  final num profit;
  final Color borderColor;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.productSold,
    required this.label,
    required this.revenue,
    required this.profit,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, size: 28, color: borderColor),
          const SizedBox(width: 12),

          // Left column (label + revenue)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              Text(
                'Revenue: $revenue',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),

          // Push the right column to the end
          const Spacer(),

          // Right column (product sold + profit)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Sold: $productSold',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                'Profit: $profit',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
