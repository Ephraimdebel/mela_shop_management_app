import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hiracosmetics/core/enums/category.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,       // selling price per unit
    required double buyPrice,    // cost per unit
    required int quantity,       // total stock
    required int soldQuantity,   // units sold so far
    required bool isSaled,       // true if fully sold
    required Category type,
    required DateTime createdAt,
    DateTime? saledAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
