import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final int rank;
  final String label;
  final num count;
  final Color borderColor;

  const OrderCard({
    super.key,
    required this.rank,
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
          // lets the rank be in circular container
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 173, 173, 173),
            ),
            padding: EdgeInsets.all(8),
            child: Text(
              '#$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              color: borderColor
            ),
          ),
          ),
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
