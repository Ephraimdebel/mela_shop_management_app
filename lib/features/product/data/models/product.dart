import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hiracosmetics/core/enums/category.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    required double buyPrice,
    required int quantity,
    required int soldQuantity,
    required bool isSaled,
    required Category type,
    DateTime? createdAt,
    DateTime? saledAt,
  }) = _Product;

  // No _$ProductFromJson usage here since we're handling Timestamps manually
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      buyPrice: (json['buyPrice'] as num).toDouble(),
      quantity: json['quantity'],
      soldQuantity: json['soldQuantity'],
      isSaled: json['isSaled'],
      type: Category.values.firstWhere((e) => e.name == json['type']),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      saledAt: (json['saledAt'] as Timestamp?)?.toDate(),
    );
  }
}

extension ProductX on Product {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'buyPrice': buyPrice,
      'quantity': quantity,
      'soldQuantity': soldQuantity,
      'isSaled': isSaled,
      'type': type.name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'saledAt': saledAt != null ? Timestamp.fromDate(saledAt!) : null,
    };
  }
}
