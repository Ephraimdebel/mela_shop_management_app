import 'package:flutter/material.dart';

enum Category { Skincare, Makeup, Haircare, Accessories, Perfume }



extension CategoryExtension on Category { 
  String get label {
    switch (this) {
      case Category.Skincare:
        return "Skincare";
      case Category.Makeup:
        return "Makeup";
      case Category.Haircare:
        return "Haircare";
      case Category.Accessories:
        return "Accessories";
      case Category.Perfume:
        return "Perfume";
    }
  }

  IconData get icon {
  switch (this) {
    case Category.Skincare:
      return Icons.spa; // 🌿 good for natural/skin products
    case Category.Makeup:
      return Icons.brush; // 🖌 represents applying makeup
    case Category.Haircare:
      return Icons.cut; // ✂️ haircut / haircare
    case Category.Accessories:
      return Icons.shopping_bag; // 👜 bags/jewelry/accessories
    case Category.Perfume:
      return Icons.local_florist; // 🌸 fragrance/perfume
  }
}

}

 /// lets have a map of categories to their icons
const categoryIcons = {
  'Skincare': Icons.spa,
  'Makeup': Icons.brush,
  'Haircare': Icons.cut,
  'Accessories': Icons.shopping_bag,
  'Perfume': Icons.local_florist,
};
