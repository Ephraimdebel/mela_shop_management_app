// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      buyPrice: (json['buyPrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      soldQuantity: (json['soldQuantity'] as num).toInt(),
      isSaled: json['isSaled'] as bool,
      type: $enumDecode(_$CategoryEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      saledAt:
          json['saledAt'] == null
              ? null
              : DateTime.parse(json['saledAt'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'buyPrice': instance.buyPrice,
      'quantity': instance.quantity,
      'soldQuantity': instance.soldQuantity,
      'isSaled': instance.isSaled,
      'type': _$CategoryEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'saledAt': instance.saledAt?.toIso8601String(),
    };

const _$CategoryEnumMap = {
  Category.Skincare: 'Skincare',
  Category.Makeup: 'Makeup',
  Category.Haircare: 'Haircare',
  Category.Accessories: 'Accessories',
  Category.Perfume: 'Perfume',
};
