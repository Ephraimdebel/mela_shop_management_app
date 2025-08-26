import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String category;
  final num price;
  final Color borderColor;
  final int count;
  final VoidCallback? onClick; // Sell button callback
  final VoidCallback? onTap;   // Card tap callback (e.g. edit)

  const ProductCard({
    super.key,
    required this.icon,
    required this.category,
    required this.label,
    required this.count,
    required this.borderColor,
    required this.price,
    this.onClick,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        color: const Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.grey),
              Text(
                category,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count ${onClick != null ? "in stock" : "sold"}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text('\$$price'),
            ],
          ),
          if (onClick != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onClick,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
    );

    // ✅ Wrap with InkWell only if onTap is provided
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
