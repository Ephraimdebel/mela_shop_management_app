import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String category;
  final num price;
  final Color borderColor;
  final int count;
  final VoidCallback? onClick;

  const ProductCard({
    super.key,
    required this.icon,
    required this.category,
    required this.label,
    required this.count,
    required this.borderColor,
    required this.price,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.grey),
              // SizedBox(width: 12),
              Text(
                category,
                style: TextStyle(
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
  }
}
