import 'package:flutter/material.dart';

class OverviewCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final num count;
  final Color borderColor;

  const OverviewCard({
    super.key,
    required this.icon,
    required this.label,
    required this.count,
    required this.borderColor,
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
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, size: 28, color: borderColor),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(label),
            ],
          ),
        ],
      ),
    );
  }
}
